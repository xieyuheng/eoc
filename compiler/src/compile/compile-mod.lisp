(import-all "deps")

(export compile-mod)

(claim compile-mod (-> mod? x86-mod?))

(define (compile-mod mod)
  (pipe mod
    check-mod
    (compose check-mod shrink)
    (compose check-mod uniquify)
    (compose check-mod rco-mod)
    (compose check-c-mod explicate-control)
    select-instructions
    uncover-live
    build-interference
    allocate-registers
    assign-homes
    patch-instructions
    prolog-and-epilog))
