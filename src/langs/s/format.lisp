(import-all "index.lisp")

(claim format-program (-> program? sexp?))

(define (format-program program)
  (match program
    ((make-program info body)
     `(program ,info ,(format-exp body)))))

(claim format-exp (-> exp? sexp?))

(define (format-exp exp)
  (match exp
    ((var-exp name) name)
    ((int-exp value) value)
    ((prim-exp op args)
     (cons op (list-map format-exp args)))
    ((let-exp name rhs body)
     `(let ((,name ,(format-exp rhs)))
        ,(format-exp body)))))
