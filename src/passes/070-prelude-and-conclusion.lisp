(import-all "deps.lisp")

(export prelude-and-conclusion)

(claim prelude-and-conclusion
  (-> x86-program? x86-program?))

(define (prelude-and-conclusion x86-program)
  x86-program)
