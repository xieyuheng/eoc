(import-all "deps")

(export select-instructions)

(claim select-instructions
  (-> c-program?
      x86-program?))

(define (select-instructions c-program)
  (match c-program
    ((cons-c-program info seqs)
     (cons-x86-program
      info
      (pipe seqs
        record-entries
        (list-map
         (lambda (entry)
           (= [label seq] entry)
           (= block (cons-block [] (select-instr-seq label seq)))
           [label block]))
        record-from-entries)))))

(claim select-instr-seq
  (-> symbol? seq?
      (list? instr?)))

(define (select-instr-seq label seq)
  (match seq
    ;; special case: tail call
    ((return-seq (prim-c-exp 'random-dice []))
     [(callq 'random_dice 0)
      (jmp 'epilog)])
    ((return-seq exp)
     (list-append
      (select-instr-assign (reg-rand 'rax) exp)
      [(jmp 'epilog)]))
    ((cons-seq stmt next-seq)
     (list-append
      (select-instr-stmt stmt)
      (select-instr-seq label next-seq)))))

(claim select-instr-stmt (-> stmt? (list? instr?)))

(define (select-instr-stmt stmt)
  (match stmt
    ;; special case: self iadd -- right
    ((assign-stmt
      (var-c-exp self-name)
      (prim-c-exp 'iadd [(var-c-exp self-name) arg2]))
     [['addq [(select-operand arg2) (var-rand self-name)]]])
    ;; special case: self iadd -- left
    ((assign-stmt
      (var-c-exp self-name)
      (prim-c-exp 'iadd [arg1 (var-c-exp self-name)]))
     [['addq [(select-operand arg1) (var-rand self-name)]]])
    ;; special case: self isub
    ((assign-stmt
      (var-c-exp self-name)
      (prim-c-exp 'isub [(var-c-exp self-name) arg2]))
     [['subq [(select-operand arg2) (var-rand self-name)]]])
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
