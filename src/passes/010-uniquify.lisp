(import-all "deps.lisp")

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
     (let-exp (format-name-in-counts name new-name-counts)
              (uniquify-exp name-counts rhs)
              (uniquify-exp new-name-counts body)))
    ((prim-exp op args)
     (prim-exp op (list-map (uniquify-exp name-counts) args)))))

(define (name-count-once name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    (record-set name 1 name-counts)
    (record-set name (iadd 1 count) name-counts)))

(define (format-name-in-counts name name-counts)
  (= count (record-get name name-counts))
  (if (null? count)
    name
    (format-name-with-count name count)))

(define (format-name-with-count name count)
  (string-to-symbol
   (string-append
    (format-sexp name)
    (string-to-subscript (format-sexp count)))))
