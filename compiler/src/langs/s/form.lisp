(import-all "deps")
(import-all "index")

(export
  form-mod
  form-exp
  form-mod-without-type
  form-exp-without-type)

(claim form-mod (-> mod? sexp?))

(define (form-mod mod)
  (match mod
    ((cons-mod info body)
     `(mod ,info ,(form-exp body)))))

(claim form-exp (-> exp? sexp?))

(define (form-exp exp)
  (match exp
    ((var-exp name) name)
    ((int-exp value) value)
    ((bool-exp value) value)
    (void-exp #void)
    ((prim-exp op args)
     (cons op (list-map form-exp args)))
    ((if-exp condition then else)
     `(if ,(form-exp condition)
        ,(form-exp then)
        ,(form-exp else)))
    ((let-exp name rhs body)
     `(let ((,name ,(form-exp rhs)))
        ,(form-exp body)))
    ((begin-exp sequence)
     (cons 'begin (list-map form-exp sequence)))
    ((the-exp type exp)
     `(the ,(form-type type)
        ,(form-exp exp)))))

(claim form-type (-> type? sexp?))

(define (form-type type)
  (match type
    (int-type 'int-t)
    (bool-type 'bool-t)
    (void-type 'void-t)))

(define (form-mod-without-type mod)
  (match mod
    ((cons-mod info body)
     `(mod ,info ,(form-exp-without-type body)))))

(define (form-exp-without-type exp)
  (match exp
    ((var-exp name) name)
    ((int-exp value) value)
    ((bool-exp value) value)
    (void-exp #void)
    ((prim-exp op args)
     (cons op (list-map form-exp-without-type args)))
    ((if-exp condition then else)
     `(if ,(form-exp-without-type condition)
        ,(form-exp-without-type then)
        ,(form-exp-without-type else)))
    ((let-exp name rhs body)
     `(let ((,name ,(form-exp-without-type rhs)))
        ,(form-exp-without-type body)))
    ((begin-exp sequence)
     (cons 'begin (list-map form-exp-without-type sequence)))
    ((the-exp type exp)
     (form-exp-without-type exp))))
