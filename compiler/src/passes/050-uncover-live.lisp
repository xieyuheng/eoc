(import-all "deps")

(export
  uncover-live live-info?
  uncover-live-before*
  uncover-live-write)

(claim live-info? (-> anything? bool?))

(define live-info?
  (tau :block-live-before-set (set? location-operand?)
       :live-after-sets (list? (set? location-operand?))))

(claim uncover-live
  (-> x86-program?
      (x86-program/block? (block/info? live-info?))))

(define (uncover-live x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= result-blocks [])
     (pipe blocks
       make-control-flow-graph
       digraph-topological-order
       list-reverse
       (list-each
        (lambda (label)
          (= block (record-get label blocks))
          ;; epilog label has no block now,
          ;; the block will be generated in later pass.
          (unless (null? block)
            (= result-block (uncover-live-block result-blocks block))
            (record-put! label result-block result-blocks)))))
     (cons-x86-program info result-blocks))))

(claim make-control-flow-graph
  (-> (record? block?)
      (digraph? symbol?)))

(define (make-control-flow-graph blocks)
  (= vertices (record-keys blocks))
  (= edges
     (pipe blocks
       record-entries
       (list-lift
        (lambda ([source-label block])
          (pipe block
            block-instrs
            jmp-labels-from-instrs
            (list-map (compose (cons source-label) list-unit)))))))
  (make-digraph vertices edges))

(define (jmp-labels-from-instrs instrs)
  (pipe instrs
    (list-select (union jmp? jmp-if?))
    (list-map
     (lambda (instr)
       (match instr
         ((jmp label) label)
         ((jmp-if cc label) label))))))

(claim uncover-live-block
  (-> (record? (block/info? live-info?)) block?
      (block/info? live-info?)))

(define (uncover-live-block blocks block)
  (match block
    ((cons-block info instrs)
     (= target-block
        (match (list-last instrs)
          ((jmp label) (record-get label blocks))
          ((jmp-if cc label) (record-get label blocks))
          (else null)))
     (= last-live-after-set
        (if (null? target-block)
          {}
          (record-get 'block-live-before-set (block-info target-block))))
     (= live-before-sets
        (uncover-live-before* blocks instrs last-live-after-set))
     (cons-block
      (record-append
       info
       [:block-live-before-set (list-head live-before-sets)
        :live-after-sets (list-push {} (list-tail live-before-sets))])
      instrs))))

(claim uncover-live-before*
  (-> (record? (block/info? live-info?))
      (list? instr?)
      (set? location-operand?)
      (list? (set? location-operand?))))

(define (uncover-live-before* blocks instrs last-live-after-set)
  (pipe instrs
    (swap list-zip (list-push null (list-tail instrs)))
    (list-fold-right
     (lambda ([instr next-instr] live-after-sets)
       (= live-after-set (list-first live-after-sets))
       (= live-before-set
          (uncover-live-before blocks instr live-after-set))
       (cons live-before-set live-after-sets))
     [last-live-after-set])
    list-init))

(claim uncover-live-before
  (-> (record? (block/info? live-info?))
      instr?
      (set? location-operand?)
      (set? location-operand?)))

(define (uncover-live-before blocks instr live-after-set)
  (= target-block
     (match instr
       ((jmp label) (record-get label blocks))
       ((jmp-if cc label) (record-get label blocks))
       (else null)))
  (cond ((null? target-block)
         (pipe live-after-set
           (swap set-difference (uncover-live-write blocks instr))
           (set-union (uncover-live-read blocks instr))))
        ((jmp? instr)
         (record-get 'block-live-before-set (block-info target-block)))
        ((jmp-if? instr)
         (set-union
          live-after-set
          (record-get 'block-live-before-set (block-info target-block))))))

(claim uncover-live-read
  (-> (record? (block/info? live-info?)) instr?
      (set? location-operand?)))

(define (uncover-live-read blocks instr)
  (match instr
    ((callq label arity)
     (list-to-set (list-take arity sysv-argument-registers)))
    (retq
     {(reg-rand 'rsp) (reg-rand 'rax)})
    ;; TODO only when label ends with .epilog
    ((jmp label)
     {(reg-rand 'rsp) (reg-rand 'rax)})
    (['addq [src dest]]
     (set-union (uncover-live-operand src)
                (uncover-live-operand dest)))
    (['subq [src dest]]
     (set-union (uncover-live-operand src)
                (uncover-live-operand dest)))
    (['movq [src dest]]
     (uncover-live-operand src))
    (['negq [dest]]
     (uncover-live-operand dest))
    (['cmpq [src dest]]
     (set-union (uncover-live-operand src)
                (uncover-live-operand dest)))))

(claim uncover-live-write
  (-> (record? (block/info? live-info?)) instr?
      (set? location-operand?)))

(define (uncover-live-write blocks instr)
  (match instr
    ((callq label arity)
     (list-to-set sysv-caller-saved-registers))
    (retq
     {(reg-rand 'rsp)})
    ;; TODO only when label ends with .epilog
    ((jmp label)
     {(reg-rand 'rsp) (reg-rand 'rax)})
    (['addq [src dest]]
     (uncover-live-operand dest))
    (['subq [src dest]]
     (uncover-live-operand dest))
    (['movq [src dest]]
     (uncover-live-operand dest))
    (['negq [dest]]
     (uncover-live-operand dest))
    (['cmpq [src dest]]
     {})))

(define (uncover-live-operand operand)
  (if (location-operand? operand) {operand} {}))
