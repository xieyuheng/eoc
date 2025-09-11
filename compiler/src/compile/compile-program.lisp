(import-all "deps.lisp")

(export compile-program optimization-level?)

(define (optimization-level? x)
  (list-member? x [null 1]))

(claim compile-program
  (-> optimization-level? program?
      x86-program?))

(define (compile-program optimization-level program)
  (pipe program
    check-program
    (if (equal? 1 optimization-level)
      (compose check-program partial-eval-program)
      identity)
    uniquify check-program
    rco-program check-program
    explicate-control check-c-program
    select-instructions
    assign-homes
    patch-instructions
    prolog-and-epilog))
