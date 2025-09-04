(import-all "deps.lisp")

;; The target language of this pass is a variant of x86 that still uses
;; variables, so we add an AST node of the form (Var var) to the arg
;; nonterminal of the x86Int abstract syntax.

(export select-instructions)

(claim select-instructions (-> c-program? x86-program?))

(define (select-instructions c-program)
  (match c-program
    ((cons-c-program info [:start seq])
     (= block (cons-block [] (select-instr-seq seq)))
     (cons-x86-program info [:start block]))))

(claim select-instr-atom (-> c-exp-atom? arg?))

(define (select-instr-atom atom)
  (match atom
    ((int-c-exp value) (imm-arg value))
    ((var-c-exp name) (var-arg name))))

(claim select-instr-assign (-> arg? c-exp? (list? instr?)))

(define (select-instr-assign arg rhs)
  (match rhs
    ((int-c-exp value)
     [['movq [(select-instr-atom rhs) arg]]])
    ((var-c-exp name)
     [['movq [(select-instr-atom rhs) arg]]])
    ((prim-c-exp 'random-dice [])
     [(callq 'random_dice)
      ['movq [(reg-arg 'rax) arg]]])
    ((prim-c-exp '- [arg])
     [['movq [(select-instr-atom arg) arg]]
      ['negq [arg]]])
    ((prim-c-exp '+ [arg1 arg2])
     [['movq [(select-instr-atom arg1) arg]]
      ['addq [(select-instr-atom arg2) arg]]])))

(claim select-instr-stmt (-> stmt? (list? instr?)))

(define (select-instr-stmt stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) (prim-c-exp '+ [(var-c-exp name) arg2]))
     [['addq [(select-instr-atom arg2) (var-arg name)]]])
    ((assign-stmt (var-c-exp name) (prim-c-exp '+ [arg1 (var-c-exp name)]))
     [['addq [(select-instr-atom arg1) (var-arg name)]]])
    ((assign-stmt (var-c-exp name) rhs)
     (select-instr-assign (var-arg name) rhs))))

(claim select-instr-seq (-> seq? (list? instr?)))

(define (select-instr-seq seq)
  (match seq
    ((cons-seq stmt next-seq)
     (list-append (select-instr-stmt stmt)
                  (select-instr-seq next-seq)))
    ((return-seq (prim-c-exp 'random-dice []))
     [(callq 'random_dice)
      (jmp 'conclusion)])
    ((return-seq exp)
     (list-append (select-instr-assign (reg-arg 'rax) exp)
                  [(jmp 'conclusion)]))))
