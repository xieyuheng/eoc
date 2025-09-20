(import-all "deps.lisp")
(import-all "index.lisp")

(export parse-c-program)

(claim parse-c-program (-> sexp? c-program?))

(define (parse-c-program sexp)
  (match sexp
    (`(c-program ,info ,seqs)
     (@c-program info (record-map parse-seq seqs)))))

(claim parse-seq (-> sexp? seq?))

(define (parse-seq sexp)
  (match sexp
    (`((return ,result))
     (return-seq (parse-c-exp result)))
    ((cons head tail)
     (cons-seq (parse-stmt head) (parse-seq tail)))))

(claim parse-stmt (-> sexp? stmt?))

(define (parse-stmt sexp)
  (match sexp
    (`(= ,name ,rhs)
     (assign-stmt (var-c-exp name) (parse-c-exp rhs)))))

(claim parse-c-exp (-> sexp? c-exp?))

(define (parse-c-exp sexp)
  (match sexp
    ((cons op args)
     (prim-c-exp op (list-map parse-atom args)))
    (_ (parse-atom sexp))))

(claim parse-atom (-> sexp? atom-c-exp?))

(define (parse-atom sexp)
  (cond ((int? sexp) (int-c-exp sexp))
        ((symbol? sexp) (var-c-exp sexp))
        (else (exit [:who 'parse-atom
                     :message "unhandled sexp"
                     :sexp sexp]))))
