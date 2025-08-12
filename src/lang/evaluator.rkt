#lang racket

(require "deps.rkt")
(require "program.rkt")

(provide evaluator-class)

(define-class evaluator-class ()
  (note evaluate-program (-> program-t value-t))
  (define/public (evaluate-program program)
    (match program
      ((Program info exp)
       ((evaluate-exp (list)) exp))))

  (note evaluate-exp (-> env-t exp-t value-t))
  (define/public ((evaluate-exp env) exp)
    (match exp
      ((Int n) n)
      ((Var name) (alist-get-or-fail env name))
      ((Prim 'read (list))
       (define r (read))
       (cond ((fixnum? r) r)
             (else (error 'evaluate-exp "expected an integer" r))))
      ((Prim '- (list e))
       (fx- 0 ((evaluate-exp env) e)))
      ((Prim '+ (list e1 e2))
       (fx+ ((evaluate-exp env) e1) ((evaluate-exp env) e2)))
      ((Prim '- (list e1 e2))
       (fx- ((evaluate-exp env) e1) ((evaluate-exp env) e2)))
      ((Let name rhs body)
       (define new-env (alist-set env name ((evaluate-exp env) rhs)))
       ((evaluate-exp new-env) body)))))
