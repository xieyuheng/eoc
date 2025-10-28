(import-all "deps")

(export compile-passes)

(claim compile-passes (-> mod? void?))

(define (compile-passes mod)
  (pipe mod
    (compose (log-mod "mod"))
    (compose (log-mod "shrink") shrink)
    (compose (log-mod "uniquify") uniquify)
    (compose (log-mod "remove-complex-operands") rco-mod)
    (compose check-c-mod (log-c-mod "explicate-control") explicate-control)
    (compose (log-x86-mod "select-instructions") select-instructions)
    (compose (log-x86-mod "uncover-live") uncover-live)
    (compose (log-x86-mod "build-interference") build-interference)
    (compose (log-x86-mod "allocate-registers") allocate-registers)
    (compose (log-x86-mod "assign-homes") assign-homes)
    (compose (log-x86-mod "patch-instructions") patch-instructions)
    (compose (log-x86-mod "prolog-and-epilog") prolog-and-epilog)
    (constant void)))

(define indentation "  ")

(define (log-mod tag mod)
  (write tag) (write ":")
  (newline) (newline)
  (write indentation) (write (format-sexp (form-mod mod)))
  (newline) (newline)
  mod)

(define (log-c-mod tag c-mod)
  (write tag) (write ":")
  (newline) (newline)
  (write (format-after-prompt indentation (pretty 80 c-mod)))
  (newline) (newline)
  c-mod)

(define (log-x86-mod tag x86-mod)
  (write tag) (write ":")
  (newline) (newline)
  (write (format-after-prompt indentation (pretty 80 x86-mod)))
  (newline) (newline)
  x86-mod)
