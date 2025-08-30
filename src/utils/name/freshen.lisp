(import-all "format-name-with-count.lisp")

(define freshen-state [:count 0])

(define (freshen name)
  (= count (record-get 'count freshen-state))
  (record-set! 'count (iadd 1 count) freshen-state)
  (format-name-with-count name (iadd 1 count)))
