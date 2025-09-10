(import-all "deps.lisp")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> x86-program? x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= blocks (record-set 'begin prolog-block blocks))
     (= blocks (record-set 'epilog epilog-block blocks))
     (cons-x86-program info blocks))))

(claim prolog-block block?)

(define prolog-block
  (cons-block
   []
   [['pushq [(reg-arg 'rbp)]]
    ['movq [(reg-arg 'rsp) (reg-arg 'rbp)]]
    ['subq [(imm-arg 16) (reg-arg 'rsp)]]
    (jmp 'start)]))

(claim epilog-block block?)

(define epilog-block
  (cons-block
   []
   [['addq [(imm-arg 16) (reg-arg 'rsp)]]
    ['popq [(reg-arg 'rbp)]]
    retq]))
