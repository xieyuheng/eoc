(import-all "deps")
(import-all "index")

(define (test-c-mod sexp)
  (= c-mod (parse-c-mod sexp))
  (check-c-mod c-mod))

(test-c-mod
 '(c-mod
   ()
   (:begin
    ((= x (ineg 1))
     (return x)))))

(test-c-mod
 '(c-mod
   ()
   (:begin
    ((= x 8)
     (branch (gt? x 1) a b)))))

(test-c-mod
 '(c-mod
   ()
   (:begin
    ((= x 8)
     (branch (eq? x 1) a b)))))

(test-c-mod
 '(c-mod
   ()
   (:begin
    ((= x 8)
     (= b (eq? x 1))
     (branch (eq? b #t) a b)))))
