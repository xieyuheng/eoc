(import-all "deps.lisp")

(export uncover-live)

(claim live-info? (-> anything? bool?))

(define live-info?
  (tau :live-after-instrs (list? (set? location-operand?))
       :live-before-block (set? location-operand?)))

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
     (cons-block
      [:live-after-instrs (uncover-live-after instrs {})
       :live-before-block {}]
      instrs))))

(claim uncover-live-after
  (-> (list? instr?) (set? location-operand?)
      (list? (set? location-operand?))))

(define (uncover-live-after instrs last-live-set)
  (list-fold-right
   (lambda (instr live-sets)
     (cons (uncover-live-instr instr (list-first live-sets))
           live-sets))
   [last-live-set]
   instrs))

(claim uncover-live-instr
  (-> instr? (set? location-operand?)
      (set? location-operand?)))

(define (uncover-live-instr instr next-live-set)
  (pipe next-live-set
    (swap set-difference (uncover-live-instr-write instr))
    (set-union (uncover-live-instr-read instr))))

(define (uncover-live-instr-read instr)
  {})

(define (uncover-live-instr-write instr)
  {})
