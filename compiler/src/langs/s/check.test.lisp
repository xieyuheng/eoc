(import-all "deps")
(import-all "index")

(define (test-program predicate sexp)
  (= program (parse-program sexp))
  (check-program program))

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

;; (test-program
;;  (equal? 1)
;;  '(program
;;    ()
;;    (let ((x 8))
;;      (if (gt? x 1)
;;        1
;;        0))))

;; (test-program
;;  (equal? 0)
;;  '(program
;;    ()
;;    (let ((x 0))
;;      (if (gt? x 1)
;;        1
;;        0))))
