#lang racket

(require "deps.rkt")

(provide assign-homes)

(note assign-homes (-> x86-program-t x86-program-t))

(define (assign-homes x86-program)
  (match x86-program
    ((X86Program info blocks)
     (X86Program
      (list (cons 'stack-space (calc-stack-space (cdr (car info)))))
      (map (lambda (ls)
             (cons (car ls) (assign-homes-block (cdr ls) (car info))))
           blocks)))))

(define (assign-homes-block b ls)
  (match b
    ((Block info es)
     (Block info (for/list ((e es)) (assign-homes-instr e ls))))))

(define (calc-stack-space ls) (* 8 (length ls)))

(define (find-index v ls)
  (cond
   ;;((eq? v (Var-name (car ls))) 1)
   ((eq? v (car ls)) 1)
   (else (add1 (find-index v (cdr ls))))))

(define (assign-homes-imm i ls)
  (match i
    ((Reg reg) (Reg reg))
    ((Imm int) (Imm int))
    ((Var v) (Deref 'rbp (* -8 (find-index v (cdr ls)))))))

(define (assign-homes-instr i ls)
  (match i
    ((Instr op (list e1))
     (Instr op (list (assign-homes-imm e1 ls))))
    ((Instr op (list e1 e2))
     (Instr op (list (assign-homes-imm e1 ls) (assign-homes-imm e2 ls))))
    (else i)))
