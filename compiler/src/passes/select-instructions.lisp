(import-all "deps.lisp")

;; The target language of this pass is a variant of x86 that still uses
;; variables, so we add an AST node of the form (Var var) to the arg
;; nonterminal of the x86Int abstract syntax.

(export select-instructions)

(claim select-instructions (-> c-program? x86-program?))

(define (select-instructions c-program)
  (match c-program
    ((@c-program info [:start seq])
     (= block (@block [] (select-instr-seq seq)))
     (@x86-program info [:start block]))))

(claim select-instr-seq (-> seq? (list? instr?)))

(define (select-instr-seq seq)
  (match seq
    ((cons-seq stmt next-seq)
     (list-append (select-instr-stmt stmt)
                  (select-instr-seq next-seq)))
    ((return-seq (prim-c-exp 'random-dice []))
     [(callq 'random_dice 0)
      (jmp 'epilog)])
    ((return-seq exp)
     (list-append (select-instr-assign (reg-rand 'rax) exp)
                  [(jmp 'epilog)]))))

(claim select-instr-stmt (-> stmt? (list? instr?)))

(define (select-instr-stmt stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) (prim-c-exp 'iadd [(var-c-exp name) arg2]))
     [['addq [(select-operand arg2) (var-rand name)]]])
    ((assign-stmt (var-c-exp name) (prim-c-exp 'iadd [arg1 (var-c-exp name)]))
     [['addq [(select-operand arg1) (var-rand name)]]])
    ((assign-stmt (var-c-exp name) rhs)
     (select-instr-assign (var-rand name) rhs))))

(claim select-instr-assign (-> operand? c-exp? (list? instr?)))

(define (select-instr-assign arg rhs)
  (match rhs
    ((int-c-exp value)
     [['movq [(select-operand rhs) arg]]])
    ((var-c-exp name)
     [['movq [(select-operand rhs) arg]]])
    ((prim-c-exp 'random-dice [])
     [(callq 'random_dice 0)
      ['movq [(reg-rand 'rax) arg]]])
    ((prim-c-exp 'ineg [arg1])
     [['movq [(select-operand arg1) arg]]
      ['negq [arg]]])
    ((prim-c-exp 'iadd [arg1 arg2])
     [['movq [(select-operand arg1) arg]]
      ['addq [(select-operand arg2) arg]]])
    ((prim-c-exp 'isub [arg1 arg2])
     [['movq [(select-operand arg1) arg]]
      ['subq [(select-operand arg2) arg]]])))

(claim select-operand (-> atom-c-exp? operand?))

(define (select-operand atom)
  (match atom
    ((int-c-exp value) (imm-rand value))
    ((var-c-exp name) (var-rand name))))
