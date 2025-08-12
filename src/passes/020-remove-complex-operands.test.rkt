#lang racket

(require "deps.rkt")
(require "010-uniquify.rkt")
(require "020-remove-complex-operands.rkt")

(define (test-program program-sexp value)
  (let* ((program-0 (parse-program program-sexp))
         (program-1 (uniquify program-0))
         (program-2 (rco-program program-1))
         (evaluator (new evaluator-class))
         (result (send evaluator evaluate-program program-2)))
    (displayln (~a "000 " (format-program program-0)))
    (displayln (~a "010 " (format-program program-1)))
    (displayln (~a "020 " (format-program program-2)))
    (assert-equal result value)))

(test-program
 '(program
   ()
   (let ((x (+ 42 (- 10))))
     (+ x 10)))
 42)

(test-program
 '(program
   ()
   (+ (+ 1 2) (+ 3 (+ 4 5))))
 15)

(test-program
 '(program
   ()
   (let ((a 42))
     (let ((b a))
       b)))
 42)
