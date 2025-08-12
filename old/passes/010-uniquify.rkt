#lang racket

(require "deps.rkt")

(provide uniquify)

(define (uniquify program)
  (match program
    ((Program info body)
     (Program info ((uniquify-exp (list)) body)))))

(define ((uniquify-exp name-table) exp)
  (match exp
    ((Var name)
     (define found-name (alist-get name-table name #f))
     (Var (or found-name name)))
    ((Int n)
     (Int n))
    ((Let name rhs body)
     (define fresh-name (freshen name))
     (define new-name-table
       (alist-set name-table name fresh-name))
     (Let fresh-name
          ((uniquify-exp name-table) rhs)
          ((uniquify-exp new-name-table) body)))
    ((Prim op args)
     (Prim op (map (uniquify-exp name-table) args)))))
