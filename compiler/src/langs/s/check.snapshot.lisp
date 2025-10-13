(import-all "deps")
(import-all "index")

(define (test-program sexp)
  (= program (parse-program sexp))
  (check-program program))

(test-program
 '(program () 8))

(test-program
 '(program () (ineg 8)))

(test-program
 '(program () (iadd 8 (ineg 8))))

(test-program
 '(program () (let ((x 8)) (iadd x x))))

(test-program
 '(program
   ()
   (let ((x 8))
     (if (gt? x 1)
       1
       0))))

(test-program
 '(program
   ()
   (let ((x 0))
     (if (gt? x 1)
       1
       0))))

(test-program
 '(program
   ()
   (let ((x 0))
     (if (eq? x 1)
       1
       0))))
