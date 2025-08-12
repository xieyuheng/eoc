#lang racket

(require "deps.rkt")

(provide (struct-out Int)
         (struct-out Prim)
         (struct-out Var)
         (struct-out Let)
         (struct-out Program))

;; <type> ::= Integer
;; <exp> ::= (Int <int>)
;;         | (Var <var>)
;;         | (Prim 'read ())
;;         | (Prim '- (<exp>))
;;         | (Prim '+ (<exp> <exp>))
;;         | (Prim '- (<exp> <exp>))
;;         | (Let <var> <exp> <exp>)
;; <program> ::= (Program '() <exp>)

(define-data Int (value))
(define-data Prim (op args))
(define-data Var (name))
(define-data Let (name rhs body))
(define-data Program (info body))

(provide format-program)

(note format-program (-> program-t sexp-t))

(define (format-program program)
  (match program
    ((Program info body)
     `(program ,info ,(format-exp body)))))

(provide format-exp)

(note format-exp (-> exp-t sexp-t))

(define (format-exp exp)
  (match exp
    ((Var name) name)
    ((Int n) n)
    ((Let name rhs body)
     `(let ((,name ,(format-exp rhs)))
        ,(format-exp body)))
    ((Prim op args)
     (cons op (map format-exp args)))))

(provide parse-program)

(note parse-program (-> sexp-t program-t))

(define (parse-program sexp)
  (match sexp
    (`(program ,info ,body)
     (Program info (parse-exp body)))))

(note parse-exp (-> sexp-t exp-t))

(define (parse-exp sexp)
  (match sexp
    (`(let ((,name ,rhs)) ,body)
     (Let name (parse-exp rhs) (parse-exp body)))
    ((cons op args)
     (Prim op (map parse-exp args)))
    (x
     (cond ((fixnum? x) (Int x))
           ((symbol? x) (Var x))
           (else (error 'parse-exp "expected an integer" x))))))
