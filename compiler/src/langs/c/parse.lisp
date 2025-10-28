(import-all "deps")
(import-all "index")

(export parse-c-mod)

(claim parse-c-mod (-> sexp? c-mod?))

(define (parse-c-mod sexp)
  (match sexp
    (`(c-mod ,info ,seqs)
     (cons-c-mod info (record-map-value parse-seq seqs)))))

(claim parse-seq (-> sexp? seq?))

(define (parse-seq sexp)
  (match sexp
    (`((return ,result))
     (return-seq (parse-c-exp result)))
    (`((goto ,label))
     (goto-seq label))
    (`((branch ,condition ,then-label ,else-label))
     (branch-seq (parse-c-exp condition)
                 then-label
                 else-label))
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
    (else (parse-atom sexp))))

(claim parse-atom (-> sexp? atom-c-exp?))

(define (parse-atom sexp)
  (cond ((int? sexp) (int-c-exp sexp))
        ((bool? sexp) (bool-c-exp sexp))
        ((symbol? sexp) (var-c-exp sexp))
        (else (exit [:who 'parse-atom
                     :message "unhandled sexp"
                     :sexp sexp]))))
