(import-all "deps")
(import "build-interference" interference-info?)

(export allocate-registers)

(claim allocate-registers
  (-> (x86-program/block?
       (block/info? interference-info?))
      (x86-program/block?
       (block/info?
        (tau :spilled-variable-count int?
             :used-callee-saved-registers (list? reg-rand?))))))

(define (allocate-registers x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map-value allocate-registers-block blocks)))))

(claim allocate-registers-block (-> block? block?))

(define (allocate-registers-block block)
  (match block
    ((cons-block info instrs)
     (= interference-graph (record-get 'interference-graph info))
     (= coloring (pre-coloring))
     (= vertices (set-to-list (graph-vertices interference-graph)))
     (graph-coloring! coloring vertices interference-graph)
     (cons-block
      (record-append
       info
       [:spilled-variable-count (count-spilled-variables coloring)
        :used-callee-saved-registers (find-used-callee-saved-registers coloring)])
      (list-map (allocate-registers-instr coloring) instrs)))))

(define (find-max-register-color coloring)
  (pipe coloring
    ;; (hash-select/key reg-rand?)
    (hash-select (lambda (location color) (reg-rand? location)))
    hash-values
    (list-foremost int-compare/descending)))

(define max-register-color
  (find-max-register-color (pre-coloring)))

(define (count-spilled-variables coloring)
  ;; TODO
  16)

(define callee-saved-registers
  (list-map reg-rand '(rsp rbp rbx r12 r13 r14 r15)))

(claim find-used-callee-saved-registers
  (-> coloring? (list? reg-rand?)))

(define (find-used-callee-saved-registers coloring)
  (list-select (coloring-use-register? coloring) callee-saved-registers))

(define (coloring-use-register? coloring register)
  (= color (hash-get register coloring))
  (= register-coloring (hash-select (drop (equal? color)) coloring))
  (int-larger? (hash-length register-coloring) 1))

(define color? int?)
(define coloring? (hash? location-operand? color?))

(define reg-name-color-hash
  (@hash
   'rcx  0  'rdx  1  'rsi  2  'rdi  3  'r8   4  'r9 5
   'r10  6  'rbx  7  'r12  8  'r13  9  'r14 10
   'rax -1  'rsp -2  'rbp -3  'r11 -4  'r15 -5))

(claim pre-coloring (-> coloring?))

(define (pre-coloring)
  (hash-map-key reg-rand reg-name-color-hash))

(define color-reg-name-hash
  (hash-invert reg-name-color-hash))

(claim allocate-registers-instr
  (-> coloring? instr?
      instr?))

(define (allocate-registers-instr coloring instr)
  (if (general-instr? instr)
    (begin
      (= [op rands] instr)
      [op (list-map (allocate-registers-operand coloring) rands)])
    instr))

(claim allocate-registers-operand
  (-> coloring? operand?
      operand?))

(define (allocate-registers-operand coloring rand)
  (match rand
    ((var-rand name)
     (= color (hash-get (var-rand name) coloring))
     (color-to-location color))
    (else rand)))

(claim color-to-location (-> color? location-operand?))

(define (color-to-location color)
  (= reg-name (hash-get color color-reg-name-hash))
  (cond ((null? reg-name)
         (= index (iadd (isub color max-register-color)
                        ;; TODO used-callee-saved-registers
                        (list-length '(rsp rbp rbx r12 r13 r14 r15))))
         (= offset (imul -8 (iadd 1 index)))
         (deref-rand 'rbp offset))
        (else
         (reg-rand reg-name))))
