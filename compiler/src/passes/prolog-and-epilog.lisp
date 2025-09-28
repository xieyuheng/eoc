(import-all "deps.lisp")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> (x86-program/info?
       (tau :stack-space int?))
      x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= stack-space (record-get 'stack-space info))
     (= blocks (record-put 'begin (prolog-block stack-space) blocks))
     (= blocks (record-put 'epilog (epilog-block stack-space) blocks))
     (cons-x86-program info blocks))))

(claim prolog-block (-> int? block?))

(define (prolog-block stack-space)
  (if (equal? 0 stack-space)
    (cons-block
     []
     [['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]
      (jmp 'start)])
    (cons-block
     []
     [['pushq [(reg-rand 'rbp)]]
      ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]
      ['subq [(imm-rand stack-space) (reg-rand 'rsp)]]
      (jmp 'start)])))

(claim epilog-block (-> int? block?))

(define (epilog-block stack-space)
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
