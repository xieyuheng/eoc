(import-all "deps")

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
    (compose check-program uniquify)
    (compose check-program rco-program)
    (compose check-c-program explicate-control)
    select-instructions
    assign-homes
    patch-instructions
    prolog-and-epilog))
