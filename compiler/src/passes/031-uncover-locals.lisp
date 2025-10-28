(import-all "deps")

(export uncover-locals)

(claim uncover-locals
  (-> c-mod?
      (c-mod/info? (tau :context (record? type?)))))

(define (uncover-locals c-mod)
  (match c-mod
    ((cons-c-mod info seqs)
     (= context [])
     (pipe seqs (record-each-value (uncover-locals-seq context)))
     (cons-c-mod
      (record-put 'context context info)
      seqs))))

(claim uncover-locals-seq
  (-> (record? type?) seq?
      void?))

(define (uncover-locals-seq context seq)
  (match seq
    ((cons-seq stmt tail)
     (uncover-locals-stmt context stmt)
     (uncover-locals-seq context tail))
    (else
     void)))

(claim uncover-locals-stmt
  (-> (record? type?) stmt?
      void?))

(define (uncover-locals-stmt context stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) type rhs)
     (record-put! name type context)
     void)))
