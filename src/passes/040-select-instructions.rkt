#lang racket

;; The target language of this pass is a variant of x86 that still uses
;; variables, so we add an AST node of the form (Var var) to the arg
;; nonterminal of the x86Int abstract syntax.

(require "deps.rkt")

(provide select-instructions)

(note select-instructions (-> c-program-t x86-program-t))
(define (select-instructions c-program)
  (match c-program
    ((CProgram info (list (cons 'start tail)))
     (define block (Block '() (select-instr-tail tail)))
     (X86Program info (list (cons 'start block))))))

(note select-instr-atm (-> atm-t arg-t))
(define (select-instr-atm atm)
  (match atm
    ((Int value) (Imm value))
    ((Var name) (Var name))))

(note select-instr-assign (-> arg-t c-exp-t (list-t instr-t)))
(define (select-instr-assign arg rhs)
  (match rhs
    ((Int value)
     (list (Instr 'movq (list (select-instr-atm rhs) arg))))
    ((Var name)
     (list (Instr 'movq (list (select-instr-atm rhs) arg))))
    ((Prim 'read '())
     (list (Callq 'read_int)
           (Instr 'movq (list (Reg 'rax) arg))))
    ((Prim '- (list arg))
     (list (Instr 'movq (list (select-instr-atm arg) arg))
           (Instr 'negq (list arg))))
    ((Prim '+ (list arg1 arg2))
     (list (Instr 'movq (list (select-instr-atm arg1) arg))
           (Instr 'addq (list (select-instr-atm arg2) arg))))))

(note select-instr-stmt (-> stmt-t (list-t instr-t)))
(define (select-instr-stmt stmt)
  (match stmt
    ((Assign (Var name) (Prim '+ (list (Var name1) arg2)))
     #:when (equal? name name1)
     (list (Instr 'addq (list (select-instr-atm arg2) (Var name)))))
    ((Assign (Var name) (Prim '+ (list arg1 (Var name2))))
     #:when (equal? name name2)
     (list (Instr 'addq (list (select-instr-atm arg1) (Var name)))))
    ((Assign var rhs)
     (select-instr-assign var rhs))))

(note select-instr-tail (-> tail-t (list-t instr-t)))
(define (select-instr-tail tail)
  (match tail
    ((Seq stmt next-tail)
     (append (select-instr-stmt stmt)
             (select-instr-tail next-tail)))
    ((Return (Prim 'read '()))
     (list (Callq 'read_int)
           (Jmp 'conclusion)))
    ((Return exp)
     (append (select-instr-assign (Reg 'rax) exp)
             (list (Jmp 'conclusion))))))
