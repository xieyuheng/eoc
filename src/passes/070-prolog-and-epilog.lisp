(import-all "deps.lisp")

(export prolog-and-epilog)

(claim prolog-and-epilog
  (-> x86-program? x86-program?))

(define (prolog-and-epilog x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info blocks))))
