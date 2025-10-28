(import-all "deps")
(import-all "index")

(export check-c-mod)

(claim check-c-mod
  (-> c-mod?
      (c-mod/info?
       (tau :context (record? type?)))))

(define (check-c-mod c-mod)
  (match c-mod
    ((cons-c-mod info seqs)
     (= context [])
     (pipe seqs
       make-control-flow-graph
       digraph-topological-order
       (list-each
        (lambda (label)
          (= seq (record-get label seqs))
          (unless (null? seq)
           (check-seq context seq)))))
     (cons-c-mod
      (record-put 'context context info)
      seqs))))

(claim make-control-flow-graph
  (-> (record? seq?)
      (digraph? symbol?)))

(define (make-control-flow-graph seqs)
  (= vertices (record-keys seqs))
  (= edges
     (pipe seqs
       record-entries
       (list-lift
        (lambda ([source-label seq])
          (pipe (seq-jmp-labels seq)
            (list-map (compose (cons source-label) list-unit)))))))
  (make-digraph vertices edges))

(claim seq-jmp-labels
  (-> seq?
      (list? symbol?)))

(define (seq-jmp-labels seq)
  (match seq
    ((cons-seq stmt tail)
     (seq-jmp-labels tail))
    ((return-seq result)
     [])
    ((goto-seq label)
     [label])
    ((branch-seq condition then-label else-label)
     [then-label else-label])))

(claim check-seq
  (-> (record? type?) seq?
      void?))

(define (check-seq context seq)
  (match seq
    ((cons-seq stmt tail)
     (check-stmt context stmt)
     (check-seq context tail))
    ((return-seq result)
     (= result-type (infer-c-exp context result))
     void)
    ((goto-seq label)
     void)
    ((branch-seq condition then-label else-label)
     (= condition-type (infer-c-exp context condition))
     (unless (equal? bool-type condition-type)
       (exit [:who 'check-seq
              :message "fail on branch"
              :context context
              :seq seq]))
     void)))

(claim check-stmt
  (->  (record? type?) stmt?
       void?))

(define (check-stmt context stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= rhs-type (infer-c-exp context rhs))
     (= found-type (record-get name context))
     (cond ((null? found-type)
            (record-put! name rhs-type context)
            void)
           ((not (equal? rhs-type found-type))
            (exit [:who 'check-stmt
                   :stmt stmt
                   :rhs-type rhs-type
                   :found-type found-type]))
           (else
            void)))))

(claim infer-c-exp
  (-> (record? type?) c-exp?
      type?))

(define (infer-c-exp context c-exp)
  (match c-exp
    ((var-c-exp name)
     (record-get name context))
    ((int-c-exp value)
     int-type)
    ((bool-c-exp value)
     bool-type)
    ((prim-c-exp 'eq? [lhs rhs])
     (= lhs-type (infer-c-exp context lhs))
     (= rhs-type (infer-c-exp context rhs))
     (unless (equal? lhs-type rhs-type)
       (exit [:who 'infer-c-exp
              :message "fail on eq?"
              :c-exp c-exp
              :lhs-type lhs-type
              :rhs-type rhs-type]))
     bool-type)
    ((prim-c-exp op args)
     (= arg-types (list-map (infer-c-exp context) args))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     return-type)))
