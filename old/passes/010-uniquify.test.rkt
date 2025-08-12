#lang racket

(require "deps.rkt")
(require "010-uniquify.rkt")

(define (test-program program-sexp value)
  (let* ((program-0 (parse-program program-sexp))
         (program-1 (uniquify program-0))
         (evaluator (new evaluator-class))
         (result (send evaluator evaluate-program program-1)))
    (displayln (~a "000 " (format-program program-0)))
    (displayln (~a "010 " (format-program program-1)))
    (assert-equal result value)))

(test-program
 '(program
   ()
   (let ((x 4))
     (- 8 x)))
 4)

(test-program
 '(program
   ()
   (let ((x 32))
     (+ (let ((x 10))
          x)
        x)))
 42)

(test-program
 '(program
   ()
   (let ((x (let ((x 4))
              (+ x 1))))
     (+ x 2)))
 7)
