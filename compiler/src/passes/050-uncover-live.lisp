(import-all "deps")

(export
  uncover-live live-info?
  uncover-live-before
  uncover-live-before*
  uncover-live-read
  uncover-live-write)

(claim live-info? (-> anything? bool?))

(define live-info?
  (tau :block-live-before-set (set? location-operand?)
       :live-after-sets (list? (set? location-operand?))))

(claim uncover-live
  (-> x86-program?
      (x86-program/block?
       (block/info? live-info?))))

(define (uncover-live x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map-value uncover-live-block blocks)))))

(claim uncover-live-block
  (-> block?
      (block/info? live-info?)))

(define (uncover-live-block block)
  (match block
    ((cons-block info instrs)
     (= live-before-sets (uncover-live-before* instrs {}))
     (cons-block
      (record-append
       info
       [:block-live-before-set (list-head live-before-sets)
        :live-after-sets (list-push {} (list-tail live-before-sets))])
      instrs))))

(claim uncover-live-before*
  (-> (list? instr?) (set? location-operand?)
      (list? (set? location-operand?))))

(define (uncover-live-before* instrs last-live-after-set)
  (list-init
   (list-fold-right
    (lambda (instr live-after-sets)
      (= live-after-set (list-first live-after-sets))
      (= live-before-set (uncover-live-before instr live-after-set))
      (cons live-before-set live-after-sets))
    [last-live-after-set]
    instrs)))

(claim uncover-live-before
  (-> instr? (set? location-operand?)
      (set? location-operand?)))

(define (uncover-live-before instr live-after-set)
  (pipe live-after-set
    (swap set-difference (uncover-live-write instr))
    (set-union (uncover-live-read instr))))

(claim uncover-live-read
  (-> instr? (set? location-operand?)))

(define (uncover-live-read instr)
  (match instr
    ((callq label arity)
     (pipe sysv-argument-registers
       (list-take arity)
       list-to-set))
    (retq
     {(reg-rand 'rsp) (reg-rand 'rax)})
    ((jmp label)
     ;; TODO only when label ends with .epilog
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
     (list-to-set sysv-caller-saved-registers))
    (retq
     {(reg-rand 'rsp)})
    ((jmp label)
     ;; TODO only when label ends with .epilog
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
