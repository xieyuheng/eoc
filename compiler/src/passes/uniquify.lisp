(import-all "deps.lisp")

(export uniquify)

(claim uniquify (-> program? program?))

(define (uniquify program)
  (match program
    ((cons-program info body)
     (cons-program info (uniquify-exp [] body)))))

(claim uniquify-exp
  (-> (record? int-non-negative?) exp? exp?))

(define (uniquify-exp name-counts exp)
  (match exp
    ((var-exp name)
     (var-exp (format-name-in-counts name name-counts)))
    ((int-exp n)
     (int-exp n))
    ((let-exp name rhs body)
     (= new-name-counts (name-count-once name name-counts))
     ;; unlike the code of the book,
     ;; because we do not use side effect,
     ;; both rhs and both need to use the new-name-counts.
     (let-exp (format-name-in-counts name new-name-counts)
              (uniquify-exp new-name-counts rhs)
              (uniquify-exp new-name-counts body)))
    ((prim-exp op args)
     (prim-exp op (list-map (uniquify-exp name-counts) args)))))

(define (name-count-once name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    (record-put name 1 name-counts)
    (record-put name (iadd 1 count) name-counts)))

(define (format-name-in-counts name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    name
    (symbol-append name (string-to-symbol (format-subscript count)))))
