(import-all "deps")
(import "uncover-live"
  live-info?
  uncover-live-write
  caller-saved-registers)

(export build-interference interference-info?)

(define interference-info?
  (tau :interference-graph (graph? location-operand?)))

(claim build-interference
  (-> (x86-program/block?
       (block/info? live-info?))
      (x86-program/block?
       (inter (block/info? live-info?)
              (block/info? interference-info?)))))

(define (build-interference x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map build-interference-block blocks)))))

(claim build-interference-block
  (-> (block/info? live-info?)
      (inter (block/info? live-info?)
             (block/info? interference-info?))))

(define (build-interference-block block)
  (match block
    ((cons-block info instrs)
     (= live-after-instrs (record-get 'live-after-instrs info))
     (= graph (make-graph
               (list-append-many
                (list-map-zip instr-edges instrs live-after-instrs))))
     (cons-block
      (record-put 'interference-graph graph info)
      instrs))))

(claim instr-edges
  (-> instr? (set? location-operand?)
      (list? (tau location-operand? location-operand?))))

(define (instr-edges instr live-after-instr)
  (match instr
    ((callq label arity)
     (list-product/no-diagonal
      (list-map reg-rand caller-saved-registers)
      (set-to-list live-after-instr)))
    (['movq [src dest]]
     (list-product/no-diagonal
      [dest]
      (list-reject (equal? src)
                   (set-to-list live-after-instr))))
    (else
     (list-product/no-diagonal
      (set-to-list (uncover-live-write instr))
      (set-to-list live-after-instr)))))
