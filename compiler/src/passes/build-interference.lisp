(import-all "deps.lisp")

(export build-interference)

(claim build-interference
  (-> x86-program?
      x86-program?))

(define (build-interference x86-program)
  x86-program)
