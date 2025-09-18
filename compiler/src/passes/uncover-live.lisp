(import-all "deps.lisp")

(export uncover-live)

(claim live-info? (-> anything? bool?))

(define live-info?
  (tau :live-before (list? (set? location-operand?))
       :live-after (list? (set? location-operand?))))

(claim uncover-live
  (-> x86-program?
      (x86-program-with-block?
       (block-with-info? live-info?))))

(define (uncover-live x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map uncover-live-block blocks)))))

(claim uncover-live-block
  (-> block?
      (block-with-info? live-info?)))

(define (uncover-live-block block)
  (match block
    ((cons-block info instrs)
     (cons-block [:live-before [] :live-after []]
                 instrs))))
