(import-all "deps")
(import "compile-program" optimization-level?)

(export compile-passes)

(claim compile-passes
  (-> optimization-level? program?
      void?))

(define (compile-passes optimization-level program)
  (match optimization-level
    (0 (compile-passes/level-0 program))
    (1 (compile-passes/level-1 program))))

(define (compile-passes/level-0 program)
  (pipe program
    (compose check-program (log-program "program"))
    (compose check-program (log-program "uniquify") uniquify)
    (compose check-program (log-program "remove-complex-operands") rco-program)
    (compose check-c-program (log-c-program "explicate-control") explicate-control)
    (compose (log-x86-program "select-instructions") select-instructions)
    (compose (log-x86-program "uncover-live") uncover-live)
    (compose (log-x86-program "build-interference") build-interference)
    (compose (log-x86-program "allocate-registers") allocate-registers)
    (compose (log-x86-program "assign-homes") assign-homes)
    (compose (log-x86-program "patch-instructions") patch-instructions)
    (compose (log-x86-program "prolog-and-epilog") prolog-and-epilog)
    (constant void)))

(define (compile-passes/level-1 program)
  (pipe program
    (compose check-program (log-program "program"))
    (compose check-program (log-program "partial-eval") partial-eval-program)
    (compose check-program (log-program "uniquify") uniquify)
    (compose check-program (log-program "remove-complex-operands") rco-program)
    (compose check-c-program (log-c-program "explicate-control") explicate-control)
    (compose (log-x86-program "select-instructions") select-instructions)
    (compose (log-x86-program "uncover-live") uncover-live)
    (compose (log-x86-program "build-interference") build-interference)
    (compose (log-x86-program "allocate-registers") allocate-registers)
    (compose (log-x86-program "assign-homes") assign-homes)
    (compose (log-x86-program "patch-instructions") patch-instructions)
    (compose (log-x86-program "prolog-and-epilog") prolog-and-epilog)
    (constant void)))

(define indentation "  ")

(define (log-program tag program)
  (write tag) (write ":")
  (write "\n") (write "\n")
  (write indentation) (write (format-sexp (form-program program)))
  (write "\n") (write "\n")
  program)

(define (log-c-program tag c-program)
  (write tag) (write ":")
  (write "\n") (write "\n")
  (write (format-left-margin indentation (pretty 80 c-program)))
  (write "\n") (write "\n")
  c-program)

(define (log-x86-program tag x86-program)
  (write tag) (write ":")
  (write "\n") (write "\n")
  (write (format-left-margin indentation (pretty 80 x86-program)))
  (write "\n") (write "\n")
  x86-program)
