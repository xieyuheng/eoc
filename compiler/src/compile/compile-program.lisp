(import-all "deps")

(export compile-program optimization-level?)

(define (optimization-level? x)
  (list-member? x [0 1 2]))

(claim compile-program
  (-> optimization-level? program?
      x86-program?))

(define (compile-program optimization-level program)
  (match optimization-level
    (0 (compile-program/level-0 program))
    (1 (compile-program/level-1 program))))

(define (compile-program/level-0 program)
  (pipe program
    check-program
    (compose check-program uniquify)
    (compose check-program rco-program)
    (compose check-c-program explicate-control)
    select-instructions
    uncover-live
    build-interference
    allocate-registers
    assign-homes
    patch-instructions
    prolog-and-epilog))

(define (compile-program/level-1 program)
  (pipe program
    check-program
    (compose check-program partial-eval-program)
    (compose check-program uniquify)
    (compose check-program rco-program)
    (compose check-c-program explicate-control)
    select-instructions
    uncover-live
    build-interference
    allocate-registers
    assign-homes
    patch-instructions
    prolog-and-epilog))
