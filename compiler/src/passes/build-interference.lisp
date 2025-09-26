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
     (= dest-list (list-map reg-rand caller-saved-registers))
     (pipe dest-list
       (list-map
        (lambda (dest)
          (pipe live-after-instr
            set-to-list
            (list-filter (negate (equal? dest)))
            (list-map (lambda (location) [location dest])))))
       list-append-many))
    (['movq [src dest]]
     (pipe live-after-instr
       set-to-list
       (list-filter (negate (union (equal? dest) (equal? src))))
       (list-map (lambda (location) [location dest]))))
    (else
     (= dest-list (set-to-list (uncover-live-write instr)))
     (pipe dest-list
       (list-map
        (lambda (dest)
          (pipe live-after-instr
            set-to-list
            (list-filter (negate (equal? dest)))
            (list-map (lambda (location) [location dest])))))
       list-append-many))))
