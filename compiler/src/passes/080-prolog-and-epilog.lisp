(import-all "deps")
(import "052-allocate-registers" register-info?)

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> (x86-program/block? (block/info? register-info?))
      x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program
      info
      (pipe blocks
        record-entries
        (list-append-map
         (lambda ([label block])
           [[label (prolog-block label (block-info block))]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog)
             (epilog-block label (block-info block))]]))
        record-from-entries)))))

(define (leave-stack-space info)
  (= [:spill-count spill-count :callee-saved callee-saved] info)
  (= callee-saved-space (imul 8 (list-length callee-saved)))
  (= stack-space (iadd callee-saved-space (imul 8 spill-count)))
  (isub (int-align 16 stack-space)
        callee-saved-space))

(claim prolog-block (-> symbol? register-info? block?))

(define (prolog-block label info)
  (= [:callee-saved callee-saved] info)
  (= stack-space (leave-stack-space info))
  (= instrs
     (list-concat
      [[['pushq [(reg-rand 'rbp)]]
        ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]]
       (pipe callee-saved
         (list-map (lambda (reg) ['pushq [reg]])))
       (if (equal? 0 stack-space)
         [(jmp (symbol-append label '.body))]
         [['subq [(imm-rand stack-space) (reg-rand 'rsp)]]
          (jmp (symbol-append label '.body))])]))
  (cons-block [] instrs))

(claim epilog-block (-> symbol? register-info? block?))

(define (epilog-block label info)
  (= [:callee-saved callee-saved] info)
  (= stack-space (leave-stack-space info))
  (= instrs
     (list-concat
      [(if (equal? 0 stack-space)
         []
         [['addq [(imm-rand stack-space) (reg-rand 'rsp)]]])
       (pipe callee-saved
         (list-map (lambda (reg) ['popq [reg]]))
         list-reverse)
       [['popq [(reg-rand 'rbp)]]
        retq]]))
  (cons-block [] instrs))
