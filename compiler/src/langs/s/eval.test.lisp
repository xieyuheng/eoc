(import-all "deps")
(import-all "index")

(define (test-program predicate sexp)
  (= program (parse-program sexp))
  (= program (check-program program))
  (= value (eval-program program))
  (assert-the predicate value))

(test-program
 (equal? 8)
 '(program () 8))

(test-program
 (equal? -8)
 '(program () (ineg 8)))

(test-program
 (equal? 0)
 '(program () (iadd 8 (ineg 8))))

(test-program
 (equal? 16)
 '(program () (let ((x 8)) (iadd x x))))
