(import-all "deps")

;; Translate c to x86 (with variables).

(export select-instructions)

(claim select-instructions
  (-> (c-mod/info?
       (tau :locals (record? type?)))
      (x86-mod/info?
       (tau :locals (record? type?)))))

(define (select-instructions c-mod)
  (match c-mod
    ((cons-c-mod info seqs)
     (cons-x86-mod
      info
      (pipe seqs
        (record-map
         (lambda (label seq)
           (= locals (record-get 'locals info))
           [label (cons-block [] (select-instr-seq label seq))])))))))

(claim select-instr-seq
  (-> symbol? seq?
      (list? instr?)))

(define (select-instr-seq label seq)
  ;; TODO should use real function name
  (= function-name 'begin)
  (match seq
    ;; special case: tail call
    ((return-seq (prim-c-exp 'random-dice []))
     [(callq 'random_dice 0)
      (jmp (symbol-append function-name '.epilog))])
    ((return-seq exp)
     (list-append
      (select-instr-assign (reg-rand 'rax) exp)
      [(jmp (symbol-append function-name '.epilog))]))
    ((goto-seq target-label)
     [(jmp target-label)])
    ((branch-seq (prim-c-exp (the cmp-op? op) [arg1 arg2])
                 then-label
                 else-label)
     (= cc (record-get op operator-condition-codes))
     [['cmpq [(select-operand arg2) (select-operand arg1)]]
      (jmp-if cc then-label)
      (jmp else-label)])
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
      type
      (prim-c-exp 'iadd [(var-c-exp self-name) arg2]))
     [['addq [(select-operand arg2) (var-rand self-name)]]])
    ;; special case: self iadd -- left
    ((assign-stmt
      (var-c-exp self-name)
      type
      (prim-c-exp 'iadd [arg1 (var-c-exp self-name)]))
     [['addq [(select-operand arg1) (var-rand self-name)]]])
    ;; special case: self isub
    ((assign-stmt
      (var-c-exp self-name)
      type
      (prim-c-exp 'isub [(var-c-exp self-name) arg2]))
     [['subq [(select-operand arg2) (var-rand self-name)]]])
    ;; special case: self not
    ((assign-stmt
      (var-c-exp self-name)
      type
      (prim-c-exp 'not [(var-c-exp self-name)]))
     [['xorq [(imm-rand 1) (var-rand self-name)]]])
    ((assign-stmt (var-c-exp name) type rhs)
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
    ((prim-c-exp 'newline [])
     [(callq 'newline 0)
      ['movq [(reg-rand 'rax) dest]]])
    ((prim-c-exp 'print-int [arg1])
     [['movq [(select-operand arg1) (reg-rand 'rdi)]]
      (callq 'print_int 1)
      ['movq [(reg-rand 'rax) dest]]])
    ((prim-c-exp 'ineg [arg1])
     [['movq [(select-operand arg1) dest]]
      ['negq [dest]]])
    ((prim-c-exp 'iadd [arg1 arg2])
     [['movq [(select-operand arg1) dest]]
      ['addq [(select-operand arg2) dest]]])
    ((prim-c-exp 'isub [arg1 arg2])
     [['movq [(select-operand arg1) dest]]
      ['subq [(select-operand arg2) dest]]])
    ((prim-c-exp 'not [arg1])
     [['movq [(select-operand arg1) dest]]
      ['xorq [(imm-rand 1) dest]]])
    ((prim-c-exp (the cmp-op? op) [arg1 arg2])
     (= cc (record-get op operator-condition-codes))
     [['cmpq [(select-operand arg2) (select-operand arg1)]]
      (set-if cc (byte-reg-rand 'al))
      [movzbq (byte-reg-rand 'al) dest]])))

(claim select-operand (-> atom-c-exp? operand?))

(define (select-operand atom)
  (match atom
    ((int-c-exp value) (imm-rand value))
    ((bool-c-exp #t) (imm-rand 1))
    ((bool-c-exp #f) (imm-rand 0))
    (void-c-exp (imm-rand 0))
    ((var-c-exp name) (var-rand name))))
