(import-all "deps.lisp")

(export patch-instructions)

(claim patch-instructions
  (-> x86-program? x86-program?))

(define (patch-instructions x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map patch-block blocks)))))

(claim patch-block
  (-> block? block?))

(define (patch-block block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-append-map patch-instr instrs)))))

(claim patch-instr
  (-> instr? (list? instr?)))

(define (patch-instr instr)
  (match instr
    ([op [(deref-arg reg-name-1 offset-1)
          (deref-arg reg-name-2 offset-2)]]
     [['movq [(deref-arg reg-name-1 offset-1) (reg-arg 'rax)]]
      [op [(reg-arg 'rax) (deref-arg reg-name-2 offset-2)]]])
    (_ [instr])))
