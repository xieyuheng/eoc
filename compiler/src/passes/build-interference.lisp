(import-all "deps.lisp")
(import "uncover-live.lisp"
  live-info?
  uncover-live-write
  caller-saved-registers)

(export build-interference)

(define interference-info?
  (tau :interference-graph (graph? location-operand?)))

(claim build-interference
  (-> (x86-program-with-block?
       (block-with-info? live-info?))
      (x86-program-with-block?
       (inter (block-with-info? live-info?)
              (block-with-info? interference-info?)))))

(define (build-interference x86-program)
  (match x86-program
    ((@x86-program info blocks)
     (@x86-program info (record-map build-interference-block blocks)))))

(claim build-interference-block
  (-> (block-with-info? live-info?)
      (inter (block-with-info? live-info?)
             (block-with-info? interference-info?))))

(define (build-interference-block block)
  (match block
    ((@block info instrs)
     (= live-after-instrs (record-get 'live-after-instrs info))
     (= graph (make-graph
               (list-append-many
                (list-map-zip instr-edges instrs live-after-instrs))))
     (@block
      (record-put 'interference-graph graph info)
      instrs))))

(claim instr-edges
  (-> instr? (set? location-operand?)
      (list? (tau location-operand? location-operand?))))

(define (instr-edges instr live-after-instr)
  (match instr
    ((callq label arity)
     (list-product-without-diagonal
      (list-map reg-rand caller-saved-registers)
      (set-to-list live-after-instr)))
    (['movq [src dest]]
     (list-product-without-diagonal
      [dest]
      (list-filter (negate (equal? src))
                   (set-to-list live-after-instr))))
    (else
     (list-product-without-diagonal
      (set-to-list (uncover-live-write instr))
      (set-to-list live-after-instr)))))

(claim list-product
  (polymorphic (A B)
    (-> (list? A) (list? B)
        (list? (tau A B)))))

(define (list-product lhs rhs)
  (list-append-many
   (pipe lhs
     (list-map
      (lambda (left)
        (pipe rhs
          (list-map (lambda (right) [left right]))))))))

(claim list-product-without-diagonal
  (polymorphic (A B)
    (-> (list? A) (list? B)
        (list? (tau A B)))))

(define (list-product-without-diagonal lhs rhs)
  (list-append-many
   (pipe lhs
     (list-map
      (lambda (left)
        (pipe rhs
          (list-filter (negate (equal? left)))
          (list-map (lambda (right) [left right]))))))))
