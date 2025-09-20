(import-all "deps.lisp")
(import "compile-program.lisp" optimization-level?)

(export compile-passes)

(claim compile-passes
  (-> optimization-level? program?
      void?))

(define (compile-passes optimization-level program)
  (pipe program
    (compose check-program (log-program "000"))
    (if (equal? 1 optimization-level)
      (compose check-program (log-program "001") partial-eval-program)
      identity)
    (compose check-program (log-program "010") uniquify)
    (compose check-program (log-program "020") rco-program)
    (compose check-c-program (log-c-program "030") explicate-control)
    (compose (log-x86-program "040") select-instructions)
    (compose (log-x86-program "050") uncover-live)
    (compose (log-x86-program "060") assign-homes)
    (compose (log-x86-program "070") patch-instructions)
    (compose (log-x86-program "080") prolog-and-epilog)
    (constant void)))

(define (log-program tag program)
  (write tag) (write " ")
  (writeln (format-sexp (form-program program)))
  program)

(define (log-c-program tag c-program)
  (write tag) (write " ")
  (writeln (format-sexp (form-c-program c-program)))
  c-program)

(define (log-x86-program tag x86-program)
  (write tag) (write " ")
  (println x86-program)
  x86-program)
