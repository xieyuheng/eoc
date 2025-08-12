#lang racket

(require "deps.rkt")

(provide (struct-out Assign)
         (struct-out Return)
         (struct-out Seq)
         (struct-out CProgram))

;; <atm> ::= (Int <int>)
;;         | (Var <var>)
;; <exp> ::= <atm>
;;         | (Prim 'read ())
;;         | (Prim '- (<atm>))
;;         | (Prim '+ (<atm> <atm>))
;;         | (Prim '- (<atm> <atm>))
;; <stmt> ::= (Assign (Var <var>) <exp>)
;; <tail> ::= (Return <exp>)
;;          | (Seq <stmt> <tail>)
;; <c-program> ::= (CProgram <info> ((<label> . <tail>) … ))

(define-data Assign (var rhs))
(define-data Return (exp))
(define-data Seq (stmt tail))
(define-data CProgram (info tails))

(provide format-c-program)

(note format-c-program (-> c-program-t sexp-t))
(define (format-c-program c-program)
  (match c-program
    ((CProgram info tails)
     `(c-program ,info ,(alist-map-value tails format-tail)))))

(define (format-tail tail)
  (match tail
    ((Return exp)
     `((return ,(format-exp exp))))
    ((Seq stmt next-tail)
     (cons (format-stmt stmt)
           (format-tail next-tail)))))

(define (format-stmt stmt)
  (match stmt
    ((Assign (Var name) rhs)
     `(assign ,name ,(format-exp rhs)))))

(provide parse-c-program)

(note parse-c-program (-> sexp-t c-program-t))

(define (parse-c-program sexp)
  (match sexp
    (`(c-program ,info ,tails)
     (CProgram info (alist-map-value tails parse-tail)))))

(note parse-tail (-> sexp-t tail-t))

(define (parse-tail sexp)
  (match sexp
    (`((return ,sexp))
     (Return (parse-exp sexp)))
    ((cons head rest)
     (Seq (parse-stmt head) (parse-tail rest)))))

(note parse-stmt (-> sexp-t stmt-t))

(define (parse-stmt sexp)
  (match sexp
    (`(assign ,name ,rhs)
     (Assign (Var name) (parse-exp rhs)))))

(note parse-exp (-> sexp-t c-exp-t))

(define (parse-exp sexp)
  (match sexp
    ((cons op args)
     (Prim op (map parse-atm args)))
    (_ (parse-atm sexp))))

(note parse-atm (-> sexp-t atm-t))

(define (parse-atm x)
  (cond ((fixnum? x) (Int x))
        ((symbol? x) (Var x))
        (else (error 'parse-exp "expected an integer" x))))
