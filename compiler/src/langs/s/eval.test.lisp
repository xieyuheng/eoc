(import-all "deps")
(import-all "index")

(define (test-mod predicate sexp)
  (= mod (parse-mod sexp))
  (= value (eval-mod mod))
  (assert-the predicate value))

(test-mod
 (equal? 8)
 '(mod () 8))

(test-mod
 (equal? -8)
 '(mod () (ineg 8)))

(test-mod
 (equal? 0)
 '(mod () (iadd 8 (ineg 8))))

(test-mod
 (equal? 16)
 '(mod () (let ((x 8)) (iadd x x))))

(test-mod
 (equal? 1)
 '(mod
   ()
   (let ((x 8))
     (if (gt? x 1)
       1
       0))))

(test-mod
 (equal? 0)
 '(mod
   ()
   (let ((x 0))
     (if (gt? x 1)
       1
       0))))

(test-mod
 (equal? 0)
 '(mod
   ()
   (let ((x 0))
     (if (eq? x 1)
       1
       0))))

(test-mod
 (equal? 1)
 '(mod
   ()
   (the int-t 1)))

(test-mod
 (equal? 3)
 '(mod
   ()
   (the int-t
     (iadd (the int-t 2)
           (the int-t 1)))))
