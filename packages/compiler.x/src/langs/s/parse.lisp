(import-all "deps")
(import-all "index")

(export parse-mod parse-exp)

(claim parse-mod (-> sexp? mod?))

(define (parse-mod sexp)
  (match sexp
    (`(mod ,info ,body)
     (cons-mod info (parse-exp body)))))

(claim parse-exp (-> sexp? exp?))

(define (parse-exp sexp)
  (match sexp
    (`(let ((,name ,rhs)) ,body)
     (let-exp name (parse-exp rhs) (parse-exp body)))
    (`(the ,type ,exp)
     (the-exp (parse-type type) (parse-exp exp)))
    (`(if ,condition ,then ,else)
     (if-exp (parse-exp condition)
             (parse-exp then)
             (parse-exp else)))
    ((cons 'begin sequence)
     (begin-exp (list-map parse-exp sequence)))
    ((cons op args)
     (prim-exp op (list-map parse-exp args)))
    (atom
     (cond ((int? atom) (int-exp atom))
           ((bool? atom) (bool-exp atom))
           ((void? atom) void-exp)
           (else (var-exp atom))))))

(claim parse-type (-> sexp? type?))

(define (parse-type sexp)
  (match sexp
    ('int-t int-type)
    ('bool-t bool-type)
    ('void-t void-type)))
