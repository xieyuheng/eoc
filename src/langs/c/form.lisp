(import-all "index.lisp")

(claim form-c-program (-> c-program? sexp?))

(define (form-c-program c-program)
  (match c-program
    ((cons-c-program info seqs)
     `(c-program ,info ,(record-map form-seq seqs)))))

(define (form-seq seq)
  (match seq
    ((return-seq result)
     `((return ,(form-c-exp result))))
    ((cons-seq stmt tail)
     (cons (form-stmt stmt)
           (form-seq tail)))))

(define (form-stmt stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     `(= ,name ,(form-c-exp rhs)))))

(claim form-c-exp (-> c-exp? sexp?))

(define (form-c-exp c-exp)
  (match c-exp
    ((var-c-exp name) name)
    ((int-c-exp value) value)
    ((prim-c-exp op args)
     (cons op (list-map form-c-exp args)))))
