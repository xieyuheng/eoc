(import-all "deps")
(import-all "index")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (check-mod mod))

(assert-equal
  (test-mod '(mod () (iadd 8 (ineg 8))))
  (test-mod
   '(mod
     ()
     (the int-t (iadd 8 (ineg 8))))))

(assert-equal
  (test-mod '(mod () (iadd 8 (ineg 8))))
  (test-mod
   '(mod
     ()
     (the int-t
       (iadd (the int-t 8)
             (the int-t
               (ineg (the int-t 8))))))))

(assert-equal
  (test-mod '(mod () (iadd 8 (ineg 8))))
  (test-mod
   '(mod
     ()
     (the int-t
       (the int-t
         (the int-t
           (iadd 8 (ineg (the int-t (the int-t (the int-t 8)))))))))))
