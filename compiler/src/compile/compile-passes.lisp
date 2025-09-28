(import-all "deps.lisp")
(import "compile-program.lisp" optimization-level?)

(export compile-passes)

(claim compile-passes
  (-> optimization-level? program?
      void?))

(define (compile-passes optimization-level program)
  (pipe program
    (compose check-program (log-program "program"))
    (if (equal? 1 optimization-level)
      (compose check-program (log-program "partial-eval") partial-eval-program)
      identity)
    (compose check-program (log-program "uniquify") uniquify)
    (compose check-program (log-program "remove-complex-operands") rco-program)
    (compose check-c-program (log-c-program "explicate-control") explicate-control)
    (compose (log-x86-program "select-instructions") select-instructions)
    (compose (log-x86-program "uncover-live") uncover-live)
    (compose (log-x86-program "build-interference") build-interference)
    (compose (log-x86-program "assign-homes") assign-homes)
    (compose (log-x86-program "patch-instructions") patch-instructions)
    (compose (log-x86-program "prolog-and-epilog") prolog-and-epilog)
    (constant void)))

(define indentation "  ")
(define (log-program tag program)
  (write tag) (writeln ":")
  (writeln "")
  (write indentation) (writeln (format-sexp (form-program program)))
  (writeln "")
  program)

(define (log-c-program tag c-program)
  (write tag) (writeln ":")
  (writeln "")
  (write indentation) (writeln (format-sexp (form-c-program c-program)))
  (writeln "")
  c-program)

(define (log-x86-program tag x86-program)
  (write tag) (writeln ":")
  (writeln "")
  (write indentation) (println x86-program)
  (writeln "")
  x86-program)
