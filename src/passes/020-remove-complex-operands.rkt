#lang racket

(require "deps.rkt")

(provide rco-program)

(define (rco-program program)
  (match program
    ((Program info body)
     (Program info (rco-exp body)))))

(provide rco-exp)

(note rco-exp (-> exp-t exp-t))

(define (rco-exp exp)
  (match exp
    ((Var name)
     (Var name))
    ((Int n)
     (Int n))
    ((Let name rhs body)
     (Let name (rco-exp rhs) (rco-exp body)))
    ((Prim op args)
     (define pairs (map rco-atom args))
     (define new-args (map car pairs))
     (define bindings (append* (map cdr pairs)))
     (make-lets bindings (Prim op new-args)))))

(note make-lets (-> (alist-t name-t exp-t) exp-t exp-t))

(define (make-lets bindings base-exp)
  (match bindings
    ('()
     base-exp)
    ((cons (cons name exp) rest-map)
     (make-lets rest-map (Let name exp base-exp)))))

(note rco-atom (-> exp-t (pair-t exp-t (alist-t name-t exp-t))))

(define (rco-atom exp)
  (match exp
    ((Var name)
     (cons (Var name) '()))
    ((Int n)
     (cons (Int n) '()))
    ((Let name rhs body)
     (define body-pair (rco-atom body))
     (define new-body (car body-pair))
     (define bindings (cdr body-pair))
     (cons new-body
           (alist-set bindings name (rco-exp rhs))))
    ((Prim op args)
     (define pairs (map rco-atom args))
     (define new-args (map car pairs))
     (define bindings (append* (map cdr pairs)))
     (define name (freshen 'tmp))
     (cons (Var name)
           ;; the order matters,
           ;; current binding should be at the outside.
           (alist-cons name (Prim op new-args) bindings)))))
