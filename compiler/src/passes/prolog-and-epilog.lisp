(import-all "deps")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> (x86-program/block?
       (block/info?
        (tau :spilled-variable-count int?
             :used-callee-saved-registers (list? reg-rand?))))
      x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program
      info
      (pipe blocks
        record-entries
        (list-append-map
         (lambda (entry)
           (= [label block] entry)
           [[label (prolog-block label block)]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog) (epilog-block label block)]]))
        record-from-entries)))))

(define (additional-stack-space block)
  (= [:spilled-variable-count spilled-variable-count
      :used-callee-saved-registers used-callee-saved-registers]
     (block-info block))
  (= callee-saved-space (imul 8 (list-length used-callee-saved-registers)))
  (= stack-space (iadd callee-saved-space (imul 8 spilled-variable-count)))
  (isub (int-align 16 stack-space)
        callee-saved-space))

(claim prolog-block (-> symbol? block? block?))

(define (prolog-block label block)
  (= [:used-callee-saved-registers used-callee-saved-registers]
     (block-info block))
  (cons-block
   []
   (list-append-many
    [[['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]]
     (pipe used-callee-saved-registers
       (list-map (lambda (reg) ['pushq [reg]])))
     [['subq [(imm-rand (additional-stack-space block)) (reg-rand 'rsp)]]
      (jmp (symbol-append label '.body))]])))

(claim epilog-block (-> symbol? block? block?))

(define (epilog-block label block)
  (= [:used-callee-saved-registers used-callee-saved-registers]
     (block-info block))
  (cons-block
   []
   (list-append-many
    [[['addq [(imm-rand (additional-stack-space block)) (reg-rand 'rsp)]]]
     (pipe used-callee-saved-registers
       (list-map (lambda (reg) ['popq [reg]]))
       list-reverse)
     [['popq [(reg-rand 'rbp)]]
      retq]])))
