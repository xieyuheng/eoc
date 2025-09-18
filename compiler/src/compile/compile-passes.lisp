(import-all "deps.lisp")
(import "compile-program.lisp" optimization-level?)

(export compile-passes)

(claim compile-passes
  (-> optimization-level? program?
      void?))

(define (compile-passes optimization-level program)
  (pipe program
    (compose (log-program "000") check-program)
    (if (equal? 1 optimization-level)
      (compose (log-program "001") check-program partial-eval-program)
      identity)
    (compose (log-program "010") check-program uniquify)
    (compose (log-program "020") check-program rco-program)
    (compose (log-c-program "030") check-c-program explicate-control)
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
  (writeln (format-sexp (form-x86-program x86-program)))
  ;; (println x86-program)
  x86-program)
