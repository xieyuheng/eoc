(import-all "deps.lisp")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> x86-program? x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= blocks (record-put 'begin prolog-block blocks))
     (= blocks (record-put 'epilog epilog-block blocks))
     (cons-x86-program info blocks))))

(claim prolog-block block?)

(define prolog-block
  (cons-block
   []
   [['pushq [(reg-rand 'rbp)]]
    ['movq [(reg-rand 'rsp) (reg-rand 'rbp)]]
    ['subq [(imm-rand 16) (reg-rand 'rsp)]]
    (jmp 'start)]))

(claim epilog-block block?)

(define epilog-block
  (cons-block
   []
   [['addq [(imm-rand 16) (reg-rand 'rsp)]]
    ['popq [(reg-rand 'rbp)]]
    retq]))
