(import-all "deps")
(import-all "index")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (check-mod mod))

(test-mod
 '(mod () 8))

(test-mod
 '(mod () (ineg 8)))

(test-mod
 '(mod () (iadd 8 (ineg 8))))

(test-mod
 '(mod () #t))

(test-mod
 '(mod () #f))

(test-mod
 '(mod () #void))

(test-mod
 '(mod () (let ((x 8)) (iadd x x))))

(test-mod
 '(mod
   ()
   (let ((x 8))
     (if (gt? x 1)
       1
       0))))

(test-mod
 '(mod
   ()
   (let ((x 0))
     (if (gt? x 1)
       1
       0))))

(test-mod
 '(mod
   ()
   (let ((x 0))
     (if (eq? x 1)
       1
       0))))
