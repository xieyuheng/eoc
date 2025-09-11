(import-all "deps.lisp")
(import "compile-program.lisp" optimization-level?)

(export compile-passes)

(claim compile-passes
  (-> optimization-level? program?
      void?))

(define (constant x y) x)

(define (identity x) x)

(define (compile-passes optimization-level program)
  (pipe program
    check-program (log-program "000")
    (if (equal? 1 optimization-level)
      (compose (log-program "001") check-program partial-eval-program)
      identity)
    uniquify check-program (log-program "010")
    rco-program check-program (log-program "020")
    explicate-control check-c-program (log-c-program "030")
    select-instructions (log-x86-program "040")
    assign-homes (log-x86-program "050")
    patch-instructions (log-x86-program "060")
    prolog-and-epilog (log-x86-program "070")
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
  x86-program)
