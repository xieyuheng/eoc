(import-all "deps")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> (x86-program/block?
       (block/info?
        (tau :stack-space int?
             :used-callee-saved-registers (list? reg-rand?))))
      x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= new-blocks [])
     (pipe blocks
       record-entries
       (list-each
        (lambda (entry)
          (= [label block] entry)
          (= [:stack-space stack-space
              :used-callee-saved-registers used-callee-saved-registers]
             (block-info block))
          (record-put-many!
           [[label
             (prolog-block label stack-space used-callee-saved-registers)]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog)
             (epilog-block label stack-space used-callee-saved-registers)]]
           new-blocks))))
     (cons-x86-program info new-blocks))))

(claim prolog-block
  (-> symbol? int? (list? reg-rand?)
      block?))

(define (prolog-block label stack-space used-callee-saved-registers)
  (cons-block
   []
   (list-append-many
    [[['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]]
     (pipe used-callee-saved-registers
       (list-map (lambda (reg) ['pushq [reg]])))
     [['subq [(imm-rand stack-space) (reg-rand 'rsp)]]
      (jmp (symbol-append label '.body))]])))

(claim epilog-block
  (-> symbol? int? (list? reg-rand?)
      block?))

(define (epilog-block label stack-space used-callee-saved-registers)
  (cons-block
   []
   (list-append-many
    [[['addq [(imm-rand stack-space) (reg-rand 'rsp)]]]
     (pipe used-callee-saved-registers
       (list-map (lambda (reg) ['popq [reg]]))
       list-reverse)
     [['popq [(reg-rand 'rbp)]]
      retq]])))
