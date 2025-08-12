#lang racket

(require "deps.rkt")
(require "010-uniquify.rkt")
(require "020-remove-complex-operands.rkt")
(require "030-explicate-control.rkt")

(define (test-program program-sexp value)
  (let* ((program-0 (parse-program program-sexp))
         (program-1 (uniquify program-0))
         (program-2 (rco-program program-1))
         (evaluator (new evaluator-class))
         (result (send evaluator evaluate-program program-2))
         (c-program-3 (explicate-control program-2))
         (c-evaluator (new c-evaluator-class))
         (c-result (send c-evaluator evaluate-c-program c-program-3)))
    (displayln (~a "000 " (format-program program-0)))
    (displayln (~a "010 " (format-program program-1)))
    (displayln (~a "020 " (format-program program-2)))
    (displayln (~a "030 " (format-c-program c-program-3)))
    (assert-equal result value)
    (assert-equal c-result value)))

(test-program
 '(program
   ()
   (let ((y (let ((x 20))
              (+ x (let ((x 22))
                     x)))))
     y))
 42)

(test-program
 '(program
   ()
   (let ((y (let ((x.1 20))
              (let ((x.2 22))
                (+ x.1 x.2)))))
     y))
 42)

(test-program
 '(program
   ()
   (let ((z (let ((y (let ((x 6))
                       x)))
              y)))
     z))
 6)
