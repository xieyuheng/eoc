(import-all "deps")

(export prolog-and-epilog)

(define info?
  (tau :spilled-variable-count int?
       :used-callee-saved-registers (list? reg-rand?)))

(claim prolog-and-epilog
  (-> (x86-program/block? (block/info? info?))
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
           [[label (prolog-block label (block-info block))]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog)
             (epilog-block label (block-info block))]]))
        record-from-entries)))))

(define (leave-stack-space info)
  (= [:spilled-variable-count spilled-variable-count
      :used-callee-saved-registers used-callee-saved-registers]
     info)
  (= callee-saved-space (imul 8 (list-length used-callee-saved-registers)))
  (= stack-space (iadd callee-saved-space (imul 8 spilled-variable-count)))
  (isub (int-align 16 stack-space)
        callee-saved-space))

(claim prolog-block (-> symbol? info? block?))

(define (prolog-block label info)
  (= [:used-callee-saved-registers used-callee-saved-registers] info)
  (= stack-space (leave-stack-space info))
  (= instrs
     (list-append-many
      [[['pushq [(reg-rand 'rbp)]]
        ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]]
       (pipe used-callee-saved-registers
         (list-map (lambda (reg) ['pushq [reg]])))
       (if (equal? 0 stack-space)
         [(jmp (symbol-append label '.body))]
         [['subq [(imm-rand stack-space) (reg-rand 'rsp)]]
          (jmp (symbol-append label '.body))])]))
  (cons-block [] instrs))

(claim epilog-block (-> symbol? info? block?))

(define (epilog-block label info)
  (= [:used-callee-saved-registers used-callee-saved-registers] info)
  (= stack-space (leave-stack-space info))
  (= instrs
     (list-append-many
      [(if (equal? 0 stack-space)
         []
         [['addq [(imm-rand stack-space) (reg-rand 'rsp)]]])
       (pipe used-callee-saved-registers
         (list-map (lambda (reg) ['popq [reg]]))
         list-reverse)
       [['popq [(reg-rand 'rbp)]]
        retq]]))
  (cons-block [] instrs))
