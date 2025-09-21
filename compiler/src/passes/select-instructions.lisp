(import-all "deps.lisp")

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
     (list-append
      (select-instr-stmt stmt)
      (select-instr-seq next-seq)))
    ((return-seq (prim-c-exp 'random-dice []))
     [(callq 'random_dice 0)
      (jmp 'epilog)])
    ((return-seq exp)
     (list-append
      (select-instr-assign (reg-rand 'rax) exp)
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

(claim select-instr-assign
  (-> location-operand? c-exp?
      (list? instr?)))

(define (select-instr-assign dest rhs)
  (match rhs
    ((int-c-exp value)
     [['movq [(select-operand rhs) dest]]])
    ((var-c-exp name)
     [['movq [(select-operand rhs) dest]]])
    ((prim-c-exp 'random-dice [])
     [(callq 'random_dice 0)
      ['movq [(reg-rand 'rax) dest]]])
    ((prim-c-exp 'ineg [arg1])
     [['movq [(select-operand arg1) dest]]
      ['negq [dest]]])
    ((prim-c-exp 'iadd [arg1 arg2])
     [['movq [(select-operand arg1) dest]]
      ['addq [(select-operand arg2) dest]]])
    ((prim-c-exp 'isub [arg1 arg2])
     [['movq [(select-operand arg1) dest]]
      ['subq [(select-operand arg2) dest]]])))

(claim select-operand (-> atom-c-exp? operand?))

(define (select-operand atom)
  (match atom
    ((int-c-exp value) (imm-rand value))
    ((var-c-exp name) (var-rand name))))
