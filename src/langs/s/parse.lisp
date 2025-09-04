(import-all "index.lisp")

(export parse-program parse-exp)

(claim parse-program (-> sexp? program?))

(define (parse-program sexp)
  (match sexp
    (`(program ,info ,body)
     (cons-program info (parse-exp body)))))

(claim parse-exp (-> sexp? exp?))

(define (parse-exp sexp)
  (match sexp
    (`(let ((,name ,rhs)) ,body)
     (let-exp name (parse-exp rhs) (parse-exp body)))
    ((cons op args)
     (prim-exp op (list-map parse-exp args)))
    (atom
     (cond ((int? atom) (int-exp atom))
           (else (var-exp atom))))))
