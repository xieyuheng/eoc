(import-all "deps")

(export uniquify)

(claim uniquify (-> program? program?))

(define (uniquify program)
  (match program
    ((cons-program info body)
     (cons-program info (uniquify-exp [] [] body)))))

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
    ((int-exp n)
     (int-exp n))
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
  (record-upsert
   (record-unit name (lambda (count) (if (null? count) 1 (iadd 1 count))))
   name-counts))

(define (generate-name-in-counts name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    name
    (symbol-append name (string-to-symbol (format-subscript count)))))
