(import-all "index.lisp")

(claim parse-exp (-> sexp? exp?))

(define (parse-exp sexp)
  (match sexp
    (`(let ((,name ,rhs)) ,body)
     (let-exp name (parse-exp rhs) (parse-exp body)))
    ((cons op args)
     (prim-exp op (list-map args parse-exp)))
    (atom
     (cond ((int? atom)
            (int-exp atom))
           (else
            (var-exp atom))))))
