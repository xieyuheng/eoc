#lang racket

(require "deps.rkt")
(require "c-program.rkt")

(provide c-evaluator-class)

(define-class c-evaluator-class (evaluator-class)
  (inherit evaluate-exp)

  (note evaluate-stmt (-> env-t stmt-t env-t))
  (define/public ((evaluate-stmt env) stmt)
    (match stmt
      ((Assign (Var name) rhs)
       (alist-set env name ((evaluate-exp env) rhs)))))

  (note evaluate-tail (-> env-t stmt-t value-t))
  (define/public ((evaluate-tail env) tail)
    (match tail
      ((Return exp)
       ((evaluate-exp env) exp))
      ((Seq stmt next-tail)
       (define new-env ((evaluate-stmt env) stmt))
       ((evaluate-tail new-env) next-tail))))

  (note evaluate-program (-> c-program-t value-t))
  (define/public (evaluate-c-program c-program)
    (match c-program
      ((CProgram _ `((start . ,tail)))
       ((evaluate-tail '()) tail)))))
