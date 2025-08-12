#lang racket

(require "deps.rkt")
(require "c-program.rkt")
(require "c-evaluator.rkt")

(define (test-c-program c-program-sexp value)
  (let* ((c-program (parse-c-program c-program-sexp))
         (c-evaluator (new c-evaluator-class))
         (result (send c-evaluator evaluate-c-program c-program)))
    (assert-equal result value)))

(test-c-program
 '(c-program
   ()
   ((start
     (return 1))))
 1)


(test-c-program
 '(c-program
   ()
   ((start
     (assign x 1)
     (return x))))
 1)

(test-c-program
 '(c-program
   ()
   ((start
     (return (+ 1 2)))))
 3)

(test-c-program
 '(c-program
   ()
   ((start
     (assign x (+ 1 2))
     (return x))))
 3)
