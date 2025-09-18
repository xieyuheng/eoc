(import-all "deps.lisp")

(export uncover-live)

(claim uncover-live (-> x86-program? x86-program?))

(define (uncover-live x86-program)
  x86-program)
