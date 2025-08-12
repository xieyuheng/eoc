#lang racket

(require "deps.rkt")

(provide explicate-control)

(note explicate-control (-> program-t c-program-t))
(define (explicate-control program)
  (match program
    ((Program info body)
     (CProgram info (list (cons 'start (explicate-tail body)))))))

(note explicate-tail (-> exp-t tail-t))
(define (explicate-tail exp)
  (match exp
    ((Var name)
     (Return (Var name)))
    ((Int n)
     (Return (Int n)))
    ((Let name rhs body)
     (explicate-assign name rhs (explicate-tail body)))
    ((Prim op args)
     ;; assume args are atoms.
     (Return (Prim op args)))))

(note explicate-assign (-> name-t exp-t tail-t tail-t))
(define (explicate-assign name rhs tail)
  (match rhs
    ((Let name2 rhs2 body)
     (define tail2 (explicate-tail body))
     (explicate-assign name2 rhs2 (tail-append name tail2 tail)))
    (_
     (Seq (Assign (Var name) rhs) tail))))

(note tail-append (-> name-t tail-t tail-t tail-t))
(define (tail-append name top-tail bottom-tail)
  (match top-tail
    ((Return exp)
     (Seq (Assign (Var name) exp) bottom-tail))
    ((Seq stmt next-tail)
     (Seq stmt (tail-append name next-tail bottom-tail)))))
