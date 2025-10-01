(import-all "index")

(define (test-c-program predicate sexp)
  (= c-program (parse-c-program sexp))
  (= value (eval-c-program c-program))
  (assert-the predicate value))

(test-c-program
 (equal? 1)
 '(c-program
   ()
   (:begin
    ((return 1)))))

(test-c-program
 (equal? 1)
 '(c-program
   ()
   (:begin
    ((= x 1)
     (return x)))))

(test-c-program
 (equal? 3)
 '(c-program
   ()
   (:begin
    ((return (iadd 1 2))))))

(test-c-program
 (equal? 3)
 '(c-program
   ()
   (:begin
    ((= x (iadd 1 2))
     (return x)))))
