(import-all "index.lisp")

(claim parse-program (-> sexp? program?))

(define (parse-program sexp)
  (match sexp
    (`(program ,info ,seqs)
     (cons-program info (record-map parse-seq seqs)))))

(claim parse-seq (-> sexp? seq?))

(define (parse-seq sexp)
  (match sexp
    (`((return ,result))
     (return-seq (parse-exp result)))
    ((cons head tail)
     (cons-seq (parse-stmt head) (parse-seq tail)))))

(claim parse-stmt (-> sexp? stmt?))

(define (parse-stmt sexp)
  (match sexp
    (`(= ,name ,rhs)
     (assign-stmt (var-exp name) (parse-exp rhs)))))

(claim parse-exp (-> sexp? exp?))

(define (parse-exp sexp)
  (match sexp
    ((cons op args)
     (prim-exp op (list-map parse-atom args)))
    (_ (parse-atom sexp))))

(claim parse-atom (-> sexp? atom-exp?))

(define (parse-atom sexp)
  (cond ((int? sexp) (int-exp sexp))
        ((symbol? sexp) (var-exp sexp))
        (else (exit [:who 'parse-exp
                     :message "unhandled sexp"
                     :sexp sexp]))))
