(define freshen-state [:count 0])

(define (freshen name)
  (= count (record-get 'count freshen-state))
  (record-set! 'count (iadd 1 count) freshen-state)
  (symbol-append-subscript name (iadd 1 count)))
