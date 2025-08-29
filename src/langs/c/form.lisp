(import-all "index.lisp")

(claim form-program (-> program? sexp?))

(define (form-program program)
  (match program
    ((cons-program info seqs)
     `(program ,info ,(record-map form-seq seqs)))))

(define (form-seq seq)
  (match seq
    ((return-seq result)
     `((return ,(form-exp result))))
    ((cons-seq stmt tail)
     (cons (form-stmt stmt)
           (form-seq tail)))))

(define (form-stmt stmt)
  (match stmt
    ((assign-stmt (var-exp name) rhs)
     `(= ,name ,(form-exp rhs)))))

(claim form-exp (-> exp? sexp?))

(define (form-exp exp)
  (match exp
    ((var-exp name) name)
    ((int-exp value) value)
    ((prim-exp op args)
     (cons op (list-map form-exp args)))
    ((let-exp name rhs body)
     `(let ((,name ,(form-exp rhs)))
        ,(form-exp body)))))
