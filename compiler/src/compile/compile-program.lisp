(import-all "deps")

(export compile-program)

(claim compile-program (-> program? x86-program?))

(define (compile-program program)
  (pipe program
    check-program
    (compose check-program shrink)
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
