(import-all "deps.lisp")

(export patch-instructions)

(claim patch-instructions
  (-> x86-program? x86-program?))

(define (patch-instructions x86-program)
  (match x86-program
    ((@x86-program info blocks)
     (@x86-program info (record-map patch-block blocks)))))

(claim patch-block
  (-> block? block?))

(define (patch-block block)
  (match block
    ((@block info instrs)
     (@block info (list-append-map patch-instr instrs)))))

(claim patch-instr
  (-> instr? (list? instr?)))

(define (patch-instr instr)
  (match instr
    ;; invalid x86 instruction with two memory location operands:
    ([op [(deref-rand reg-name-1 offset-1)
          (deref-rand reg-name-2 offset-2)]]
     [['movq [(deref-rand reg-name-1 offset-1) (reg-rand 'rax)]]
      [op [(reg-rand 'rax) (deref-rand reg-name-2 offset-2)]]])
    (_ [instr])))
