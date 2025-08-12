#lang racket

(require "deps.rkt")
(require "program.rkt")
(require "evaluator.rkt")
(require "checker.rkt")

(define (test-program program-sexp value)
  (let* ((program (parse-program program-sexp))
         (checker (new checker-class))
         (program (send checker type-check-program program))
         (evaluator (new evaluator-class))
         (result (send evaluator evaluate-program program)))
    (assert-equal result value)))

(test-program
 '(program () 1)
 1)

(test-program
 '(program () (- 8))
 -8)

(test-program
 '(program () (- 8 4))
 4)

(test-program
 '(program () (let ((x 4)) (- 8 x)))
 4)
