(import-all "deps")
(import-all "index")

(export form-program form-exp)

(claim form-program (-> program? sexp?))

(define (form-program program)
  (match program
    ((cons-program info body)
     `(program ,info ,(form-exp body)))))

(claim form-exp (-> exp? sexp?))

(define (form-exp exp)
  (match exp
    ((var-exp name) name)
    ((int-exp value) value)
    ((bool-exp value) value)
    ((prim-exp op args)
     (cons op (list-map form-exp args)))
    ((if-exp condition then else)
     `(if ,(form-exp condition)
        ,(form-exp then)
        ,(form-exp else)))
    ((let-exp name rhs body)
     `(let ((,name ,(form-exp rhs)))
        ,(form-exp body)))))
