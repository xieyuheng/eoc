(import-all "deps")
(import-all "index")

(define (echo-mod sexp)
  (pipe sexp
    parse-mod
    form-mod
    format-sexp
    write)
  (newline))

(echo-mod
 '(mod () 8))

(echo-mod
 '(mod () (ineg 8)))

(echo-mod
 '(mod () (iadd 8 (ineg 8))))

(echo-mod
 '(mod () (let ((x 8)) (iadd x x))))
