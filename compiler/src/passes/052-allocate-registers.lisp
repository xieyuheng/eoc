(import-all "deps")
(import "051-build-interference" interference-info?)
(import "060-assign-homes" home-info?)

(export allocate-registers register-info?)

(define register-info?
  (tau :spill-count int?
       :callee-saved (list? reg-rand?)))

(define color? int?)

(define coloring? (hash? location-operand? color?))

;; for testing with limited registers:

(define reg-name-color-hash
  (@hash
    ;; use caller saved registers first:
    'rcx  0
    ;; use callee saved registers unwillingly:
    'rbx  1
    ;; pre color preserved registers with negative color,
    ;; otherwise they will be colored by registers too.
    'rax -1  'rsp -2  'rbp -3  'r11 -4  'r15 -5))

(@comment
  (define reg-name-color-hash
    (@hash
      ;; use caller saved registers first:
      'rcx  0  'rdx  1  'rsi  2  'rdi  3
      'r8   4  'r9   5  'r10  6
      ;; use callee saved registers unwillingly:
      'rbx  7  'r12  8  'r13  9  'r14 10
      ;; pre color preserved registers with negative color,
      ;; otherwise they will be colored by registers too.
      'rax -1  'rsp -2  'rbp -3  'r11 -4  'r15 -5)))

(claim allocate-registers
  (-> (x86-program/block? (block/info? interference-info?))
      (x86-program/block? (block/info? (inter register-info? home-info?)))))

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
     (= register-info
        [:spill-count (count-spilled-variables coloring)
         :callee-saved (find-callee-saved coloring)])
     (= variables (list-select var-rand? vertices))
     (= home-info
        [:home-locations
         (hash-from-map
          (allocate-registers-variable coloring register-info)
          variables)])
     (cons-block
      (pipe info
        (record-append register-info)
        (record-append home-info))
      instrs))))

(claim pre-coloring (-> coloring?))

(define (pre-coloring)
  (hash-map-key reg-rand reg-name-color-hash))

(claim count-spilled-variables (-> coloring? int?))

(define (count-spilled-variables coloring)
  (pipe coloring
    (hash-reject-key reg-rand?)
    (hash-select-value (swap int-larger? max-register-color))
    hash-length))

(claim find-callee-saved (-> coloring? (list? reg-rand?)))

(define (find-callee-saved coloring)
  (list-select (coloring-use-register? coloring)
               sysv-callee-saved-registers))

(define (coloring-use-register? coloring register)
  (= color (hash-get register coloring))
  (= register-coloring (hash-select (drop (equal? color)) coloring))
  (int-larger? (hash-length register-coloring) 1))

(claim allocate-registers-variable
  (-> coloring? register-info? var-rand?
      operand?))

(define (allocate-registers-variable coloring info variable)
  (= color (hash-get variable coloring))
  (color-to-location coloring info color))

(claim color-to-location
  (-> coloring? register-info? color?
      location-operand?))

(define (color-to-location coloring info color)
  (= register (hash-get color color-register-hash))
  (cond ((not (null? register)) register)
        (else
         (= [:callee-saved callee-saved] info)
         (= base-index (list-length callee-saved))
         (= color-count (isub color max-register-color))
         (= color-index (isub color-count 1))
         (= index (iadd color-index base-index))
         (= offset (imul -8 (iadd 1 index)))
         (deref-rand 'rbp offset))))

(define color-register-hash (hash-invert (pre-coloring)))

(define max-register-color
  (find-max-register-color (pre-coloring)))

(define (find-max-register-color coloring)
  (pipe coloring
    (hash-select-key reg-rand?)
    hash-values
    (list-foremost int-compare-descending)))
