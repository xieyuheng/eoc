(import-all "deps")

(export uncover-locals)

(claim uncover-locals
  (-> c-mod?
      (c-mod/info? (tau :locals (record? type?)))))

(define (uncover-locals c-mod)
  (match c-mod
    ((cons-c-mod info seqs)
     (= locals [])
     (pipe seqs (record-each-value (uncover-locals-seq locals)))
     (cons-c-mod
      (record-put 'locals locals info)
      seqs))))

(claim uncover-locals-seq
  (-> (record? type?) seq?
      void?))

(define (uncover-locals-seq locals seq)
  (match seq
    ((cons-seq stmt tail)
     (uncover-locals-stmt locals stmt)
     (uncover-locals-seq locals tail))
    (else
     void)))

(claim uncover-locals-stmt
  (-> (record? type?) stmt?
      void?))

(define (uncover-locals-stmt locals stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) type rhs)
     (record-put! name type locals)
     void)))
