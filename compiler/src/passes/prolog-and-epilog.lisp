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
     (cons-x86-program
      info
      (pipe blocks
        record-entries
        (list-append-map
         (lambda (entry)
           (= [label block] entry)
           (= [:stack-space stack-space
               :used-callee-saved-registers used-callee-saved-registers]
              (block-info block))
           [[label (prolog-block label stack-space used-callee-saved-registers)]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog)
             (epilog-block label stack-space used-callee-saved-registers)]]))
        record-from-entries)))))

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
