(import-all "deps")
(import "050-uncover-live"
  live-info?
  uncover-live-write)

(export build-interference interference-info?)

(define interference-info?
  (tau :interference-graph (graph? location-operand?)))

(claim build-interference
  (-> (inter
        (x86-program/info? (tau :context (record? type?)))
        (x86-program/block? (block/info? live-info?)))
      (x86-program/info? interference-info?)))

(define (build-interference x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= [:context context] info)
     (= vertices (list-map var-rand (record-keys context)))
     (= edges
        (pipe blocks
          record-values
          (list-lift build-interference-block)))
     (= graph (make-graph vertices edges))
     (cons-x86-program
      (record-put 'interference-graph graph info)
      blocks))))

(claim build-interference-block
  (-> (block/info? live-info?)
      (list? (tau location-operand? location-operand?))))

(define (build-interference-block block)
  (match block
    ((cons-block info instrs)
     (= [:live-after-sets live-after-sets] info)
     (list-concat (list-map-zip instr-edges instrs live-after-sets)))))

(claim instr-edges
  (-> instr? (set? location-operand?)
      (list? (tau location-operand? location-operand?))))

(define (instr-edges instr live-after-set)
  (list-reject
   (apply equal?)
   (match instr
     ((callq label arity)
      (list-product
       sysv-caller-saved-registers
       (set-to-list live-after-set)))
     ;; in a move instruction, src does not interference with dest,
     ;; because after this instruction they will have the same value
     ;; (thus the same register can be allocated to them).
     (['movq [src dest]]
      (list-product
       [dest]
       (list-reject
        (equal? src)
        (set-to-list live-after-set))))
     (['movzbq [src dest]]
      (= src (extend-byte-register src))
      (list-product
       [dest]
       (list-reject
        (equal? src)
        (set-to-list live-after-set))))
     (else
      (list-product
       (set-to-list (uncover-live-write [] instr))
       (set-to-list live-after-set))))))
