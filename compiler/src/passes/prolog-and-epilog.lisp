(import-all "deps")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> (x86-program/info?
       (tau :stack-space int?))
      x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= stack-space (record-get 'stack-space info))
     (= new-blocks [])
     (pipe blocks
       record-entries
       (list-each
        (lambda (entry)
          (= [label block] entry)
          (record-put-many!
           [[label (prolog-block label stack-space)]
            [(symbol-append label '.body) block]
            [(symbol-append label '.epilog) (epilog-block label stack-space)]]
           new-blocks))))
     (cons-x86-program info new-blocks))))

(claim prolog-block (-> symbol? int? block?))

(define (prolog-block label stack-space)
  (if (equal? 0 stack-space)
    (cons-block
     []
     [['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]
      (jmp (symbol-append label '.body))])
    (cons-block
     []
     [['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]
      ['subq [(imm-rand stack-space) (reg-rand 'rsp)]]
      (jmp (symbol-append label '.body))])))

(claim epilog-block (-> symbol? int? block?))

(define (epilog-block label stack-space)
  (if (equal? 0 stack-space)
    (cons-block
     []
     [['popq [(reg-rand 'rbp)]]
      retq])
    (cons-block
     []
     [['addq [(imm-rand stack-space) (reg-rand 'rsp)]]
      ['popq [(reg-rand 'rbp)]]
      retq])))
