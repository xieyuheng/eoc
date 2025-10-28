(import-all "deps")

;; Consistently rename every variable (introduced by let) to a unique name.

(export uniquify)

(claim uniquify (-> mod? mod?))

(define (uniquify mod)
  (match mod
    ((cons-mod info body)
     (cons-mod info (uniquify-exp [] [] body)))))

(claim uniquify-exp
  (-> (record? int-non-negative?)
      (record? symbol?)
      exp? exp?))

(define (uniquify-exp name-counts name-table exp)
  (match exp
    ((var-exp name)
     (= found-name (record-get name name-table))
     (var-exp (if (null? found-name)
                name
                found-name)))
    ((int-exp value)
     (int-exp value))
    ((bool-exp value)
     (bool-exp value))
    (void-exp
     void-exp)
    ((if-exp condition then else)
     (if-exp (uniquify-exp name-counts name-table condition)
             (uniquify-exp name-counts name-table then)
             (uniquify-exp name-counts name-table else)))
    ((let-exp name rhs body)
     (= new-name-counts (count-name name name-counts))
     (= new-name (generate-name-in-counts name new-name-counts))
     (= new-name-table (record-put name new-name name-table))
     (let-exp new-name
              (uniquify-exp new-name-counts name-table rhs)
              (uniquify-exp new-name-counts new-name-table body)))
    ((prim-exp op args)
     (prim-exp op (list-map (uniquify-exp name-counts name-table) args)))))

(define (count-name name name-counts)
  (record-update
   name (with-default-argument 0 (iadd 1))
   name-counts))

(define (generate-name-in-counts name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    name
    (symbol-append name (string-to-symbol (format-subscript count)))))
