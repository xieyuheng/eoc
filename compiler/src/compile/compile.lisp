(import-all "deps.lisp")

(export
  compile-program)

(claim compile-program
  (-> program? x86-program?))

(define (compile-program program)
  (pipe program
    check-program
    uniquify check-program
    rco-program check-program
    explicate-control check-c-program
    select-instructions
    assign-homes
    patch-instructions
    prolog-and-epilog))
