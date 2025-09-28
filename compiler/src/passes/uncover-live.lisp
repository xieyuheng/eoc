(import-all "deps.lisp")

(export
  uncover-live live-info?
  uncover-live-before
  uncover-live-before*
  uncover-live-read
  uncover-live-write
  caller-saved-registers
  callee-saved-registers)

(claim live-info? (-> anything? bool?))

(define live-info?
  (tau :live-after-instrs (list? (set? location-operand?))
       :live-before-block (set? location-operand?)))

(claim uncover-live
  (-> x86-program?
      (x86-program/block?
       (block/info? live-info?))))

(define (uncover-live x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map uncover-live-block blocks)))))

(claim uncover-live-block
  (-> block?
      (block/info? live-info?)))

(define (uncover-live-block block)
  (match block
    ((cons-block info instrs)
     (= live-before-sets (uncover-live-before* instrs {}))
     (cons-block
      [:live-after-instrs (list-push {} live-before-sets)
       :live-before-block (list-head live-before-sets)]
      instrs))))

(claim uncover-live-before*
  (-> (list? instr?) (set? location-operand?)
      (list? (set? location-operand?))))

(define (uncover-live-before* instrs last-live-set)
  (list-fold-right
   (lambda (instr live-sets)
     (cons (uncover-live-before instr (list-first live-sets))
           live-sets))
   [last-live-set]
   instrs))

(claim uncover-live-before
  (-> instr? (set? location-operand?)
      (set? location-operand?)))

(define (uncover-live-before instr next-live-set)
  (pipe next-live-set
    (swap set-difference (uncover-live-write instr))
    (set-union (uncover-live-read instr))))

(define caller-saved-registers
  '(rax rcx rdx rsi rdi r8 r9 r10 r11))

(define callee-saved-registers
  '(rsp rbp rbx r12 r13 r14 r15))

(define argument-registers
  '(rdi rsi rdx rcx r8 r9))

(claim uncover-live-read
  (-> instr? (set? location-operand?)))

(define (uncover-live-read instr)
  (match instr
    ((callq label arity)
     (pipe argument-registers
       (list-map reg-rand)
       (list-take arity)
       list-to-set))
    (retq
     {(reg-rand 'rsp) (reg-rand 'rax)})
    ((jmp 'epilog)
     {(reg-rand 'rsp) (reg-rand 'rax)})
    (['addq [src dest]]
     (set-union
      (uncover-live-operand src)
      (uncover-live-operand dest)))
    (['subq [src dest]]
     (set-union
      (uncover-live-operand src)
      (uncover-live-operand dest)))
    (['movq [src dest]]
     (uncover-live-operand src))
    (['negq [dest]]
     (uncover-live-operand dest))
    ([op rands]
     (exit [:who 'uncover-live-read
            :message "unknown op"
            :op op :rands rands]))))

(claim uncover-live-write
  (-> instr? (set? location-operand?)))

(define (uncover-live-write instr)
  (match instr
    ((callq label arity)
     (pipe caller-saved-registers
       (list-map reg-rand)
       list-to-set))
    (retq
     {(reg-rand 'rsp)})
    ((jmp 'epilog)
     {(reg-rand 'rsp) (reg-rand 'rax)})
    (['addq [src dest]]
     (uncover-live-operand dest))
    (['subq [src dest]]
     (uncover-live-operand dest))
    (['movq [src dest]]
     (uncover-live-operand dest))
    (['negq [dest]]
     (uncover-live-operand dest))
    ([op rands]
     (exit [:who 'uncover-live-write
            :message "unknown op"
            :op op :rands rands]))))

(define (uncover-live-operand operand)
  (if (location-operand? operand) {operand} {}))
