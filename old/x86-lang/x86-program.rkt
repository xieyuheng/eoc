#lang racket

(require "deps.rkt")

(provide (struct-out Imm)
         (struct-out Reg)
         (struct-out Deref)
         (struct-out Instr)
         (struct-out Callq)
         (struct-out Retq)
         (struct-out Jmp)
         (struct-out Block)
         (struct-out X86Program))

;; <reg> ::= rsp | rbp | rax | rbx | rcx | rdx | rsi | rdi
;;         | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15
;; <arg> ::= (Imm <int>)
;;         | (Reg <reg>)
;;         | (Deref <reg> <int>)
;; <instr> ::= (Instr addq (<arg> <arg>))
;;           | (Instr subq (<arg> <arg>))
;;           | (Instr negq (<arg>))
;;           | (Instr movq (<arg> <arg>))
;;           | (Instr pushq (<arg>))
;;           | (Instr popq (<arg>))
;;           | (Callq <label> <int>)
;;           | (Retq)
;;           | (Jmp <label>)
;; <block> ::= (Block <info> (<instr> … ))
;; <x86Int> ::= (X86Program <info> ((<label> . <block>) … ))

(define-data Imm (value))
(define-data Reg (name))
(define-data Deref (reg offset))
(define-data Instr (name arg*))
(define-data Callq (target arity))
(define-data Retq ())
(define-data Jmp (target))
(define-data Block (info instr*))
(define-data X86Program (info blocks))

(provide format-x86-program)

(note format-x86-program (-> x86-program-t sexp-t))
(define (format-x86-program x86-program)
  (match x86-program
    ((X86Program info blocks)
     `(x86-program ,info ,(alist-map-value blocks format-block)))))

(note format-block (-> block-t sexp-t))
(define (format-block block)
  (match block
    ((Block info instr*)
     `(block ,info ,(map format-instr instr*)))))

(note format-instr (-> instr-t (list-t string-t)))
(define (format-instr instr)
  (list (format-instr-string instr)))

(note format-instr-string (-> instr-t string-t))
(define (format-instr-string instr)
  (match instr
    ((Instr name arg*)
     (~a #:separator " "
         name (apply ~a #:separator ", " (map format-arg arg*))))
    ((Callq target arity)
     (~a #:separator " "
         "callq" (~a #:separator ", " target arity)))
    ((Retq)
     (~a #:separator " "
         "retq"))
    ((Jmp target)
     (~a #:separator " "
         "jmp" target))))

(note format-arg (-> arg-t string-t))
(define (format-arg arg)
  (match arg
    ((Var name)
     (~a name))
    ((Imm value)
     (~a "$" value))
    ((Reg name)
     (~a "%" name))
    ((Deref reg offset)
     (~a offset "(" "%" reg ")"))))
