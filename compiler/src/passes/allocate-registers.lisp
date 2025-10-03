(import-all "deps")
(import "build-interference" interference-info?)

(export allocate-registers register-info?)

(define register-info?
  (tau :spill-count int?
       :callee-saved (list? reg-rand?)))

(claim allocate-registers
  (-> (x86-program/block?
       (block/info? interference-info?))
      (x86-program/block?
       (block/info? register-info?))))

(define (allocate-registers x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map-value allocate-registers-block blocks)))))

(define color? int?)

(define coloring? (hash? location-operand? color?))

;; for testing with limited registers:

(define reg-name-color-hash
  (@hash
   'rcx  0  'rbx  1
   'rax -1  'rsp -2  'rbp -3  'r11 -4  'r15 -5))

;; (define reg-name-color-hash
;;   (@hash
;;    'rcx  0  'rdx  1  'rsi  2  'rdi  3  'r8   4  'r9 5
;;    'r10  6  'rbx  7  'r12  8  'r13  9  'r14 10
;;    ;; use negative color to avoid coloring register by register.
;;    'rax -1  'rsp -2  'rbp -3  'r11 -4  'r15 -5))

(claim pre-coloring (-> coloring?))

(define (pre-coloring)
  (hash-map-key reg-rand reg-name-color-hash))

(claim allocate-registers-block (-> block? block?))

(define (allocate-registers-block block)
  (match block
    ((cons-block info instrs)
     (= interference-graph (record-get 'interference-graph info))
     (= coloring (pre-coloring))
     (= vertices (set-to-list (graph-vertices interference-graph)))
     (graph-coloring! coloring vertices interference-graph)
     (= register-info
        [:spill-count (count-spilled-variables coloring)
         :callee-saved (find-callee-saved coloring)])
     (cons-block
      (record-append info register-info)
      (list-map (allocate-registers-instr coloring register-info) instrs)))))

(claim allocate-registers-instr
  (-> coloring? register-info? instr?
      instr?))

(define (allocate-registers-instr coloring info instr)
  (if (general-instr? instr)
    (begin
      (= [op operands] instr)
      [op (list-map (allocate-registers-operand coloring info) operands)])
    instr))

(claim allocate-registers-operand
  (-> coloring? register-info? operand?
      operand?))

(define (allocate-registers-operand coloring info operand)
  (match operand
    ((var-rand name)
     (= color (hash-get (var-rand name) coloring))
     (color-to-location coloring info color))
    (else operand)))

(claim color-to-location
  (-> coloring? register-info? color?
      location-operand?))

(define color-reg-name-hash
  (hash-invert reg-name-color-hash))

(define (color-to-location coloring info color)
  (= reg-name (hash-get color color-reg-name-hash))
  (cond ((null? reg-name)
         (= [:callee-saved callee-saved] info)
         (= base-index (list-length callee-saved))
         (= color-count (isub color max-register-color))
         (= color-index (isub color-count 1))
         (= index (iadd color-index base-index))
         (= offset (imul -8 (iadd 1 index)))
         (deref-rand 'rbp offset))
        (else
         (reg-rand reg-name))))

(define (find-max-register-color coloring)
  (pipe coloring
    ;; (hash-select-by-key reg-rand?)
    (hash-select (lambda (location color) (reg-rand? location)))
    hash-values
    (list-foremost int-compare/descending)))

(define max-register-color
  (find-max-register-color (pre-coloring)))

(define (count-spilled-variables coloring)
  (pipe coloring
    ;; (hash-reject-by-key reg-rand?)
    ;; (hash-select-by-value (swap int-larger? max-register-color))
    (hash-reject (lambda (location color) (reg-rand? location)))
    (hash-select (lambda (location color) (int-larger? color max-register-color)))
    hash-length))

(define callee-saved-registers
  (list-map reg-rand '(rsp rbp rbx r12 r13 r14 r15)))

(claim find-callee-saved
  (-> coloring? (list? reg-rand?)))

(define (find-callee-saved coloring)
  (list-select (coloring-use-register? coloring) callee-saved-registers))

(define (coloring-use-register? coloring register)
  (= color (hash-get register coloring))
  (= register-coloring (hash-select (drop (equal? color)) coloring))
  (int-larger? (hash-length register-coloring) 1))
