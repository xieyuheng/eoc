(import-all "index.lisp")

(claim format-program (-> program? sexp?))

(define (format-program program)
  (match program
    ((make-program info seqs)
     `(program ,info ,(record-map format-seq seqs)))))

(define (format-seq seq)
  (match seq
    ((return-seq result)
     `((return ,(format-exp result))))
    ((cons-seq stmt tail)
     (cons (format-stmt stmt)
           (format-seq tail)))))

(define (format-stmt stmt)
  (match stmt
    ((assign-stmt (var-exp name) rhs)
     `(= ,name ,(format-exp rhs)))))

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
