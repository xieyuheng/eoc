(import-all "deps.lisp")

(export compile-program)

(define (optimization-level? x)
  (list-member? x [null 1]))

(claim compile-program
  (-> program? optimization-level? x86-program?))

(define (identity x) x)

(define (compile-program program optimization-level)
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
