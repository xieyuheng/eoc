#lang racket

(require "deps.rkt")
(require "program.rkt")

(provide checker-class)

(define-class checker-class ()
  (define/public (operator-types)
    '((+ . ((Integer Integer) . Integer))
      (- . ((Integer Integer) . Integer))
      (read . (() . Integer))))

  (define/public (type-equal? t1 t2) (equal? t1 t2))

  (note check-type-equal? (-> type-t type-t exp-t))
  (define/public (check-type-equal? t1 t2 exp)
    (unless (type-equal? t1 t2)
      (error 'type-check "~a != ~a\nin ~v" t1 t2 exp)))

  (note type-check-op (-> op-t (list-t type-t) exp-t type-t))
  (define/public (type-check-op op arg-types exp)
    (match-define (cons expected-arg-types return-type)
      (alist-get-or-fail (operator-types) op))
    (for ((arg-type arg-types)
          (expected-arg-type expected-arg-types))
      (check-type-equal? arg-type expected-arg-type exp))
    return-type)

  (note type-check-exp (-> env-t exp-t (pair-t exp-t type-t)))
  (define/public ((type-check-exp env) exp)
    (match exp
      ((Var name)
       (cons (Var name) (alist-get-or-fail env name)))
      ((Int value)
       (cons (Int value) 'Integer))
      ((Prim op args)
       (define arg-pairs (map (type-check-exp env) args))
       (define args^ (map car arg-pairs))
       (define types (map cdr arg-pairs))
       (cons (Prim op args^) (type-check-op op types exp)))
      ((Let name rhs body)
       (match-define (cons rhs^ rhs-type)
         ((type-check-exp env) rhs))
       (match-define (cons body^ body-type)
         ((type-check-exp (alist-set env name rhs-type)) body))
       (cons (Let name rhs^ body^) body-type))))

  (define/public (type-check-program program)
    (match program
      ((Program info body)
       (match-define (cons body^ t)
         ((type-check-exp '()) body))
       (check-type-equal? t 'Integer body)
       (Program info body^)))))
