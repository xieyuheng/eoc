(import-all "deps")
(import "050-uncover-live"
  live-info?
  uncover-live-write)

(export build-interference interference-info?)

(define interference-info?
  (tau :interference-graph (graph? location-operand?)))

(claim build-interference
  (-> (x86-program/block? (block/info? live-info?))
      (x86-program/block? (block/info? interference-info?))))

(define (build-interference x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map-value build-interference-block blocks)))))

(claim build-interference-block
  (-> (block/info? live-info?)
      (block/info? interference-info?)))

(define (build-interference-block block)
  (match block
    ((cons-block info instrs)
     (= live-after-sets (record-get 'live-after-sets info))
     (= edges (list-append-many
               (list-map-zip instr-edges instrs live-after-sets)))
     (= graph (make-graph [] edges))
     (cons-block (record-put 'interference-graph graph info) instrs))))

(claim instr-edges
  (-> instr? (set? location-operand?)
      (list? (tau location-operand? location-operand?))))

(define (instr-edges instr live-after-set)
  (match instr
    ((callq label arity)
     (list-product-without-diagonal
      sysv-caller-saved-registers
      (set-to-list live-after-set)))
    ;; in a move instruction, src does not interference with dest,
    ;; because after this instruction they will have the same value
    ;; (thus the same register can be allocated to them).
    (['movq [src dest]]
     (list-product-without-diagonal
      [dest]
      (list-reject
       (equal? src)
       (set-to-list live-after-set))))
    (else
     (list-product-without-diagonal
      (set-to-list (uncover-live-write instr))
      (set-to-list live-after-set)))))
