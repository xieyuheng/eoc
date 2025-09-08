(import-all "deps.lisp")
(import-all "index.lisp")

(export form-x86-program)

(claim form-x86-program (-> x86-program? sexp?))

(define (form-x86-program x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     `(x86-program ,(form-info info) ,(record-map form-block blocks)))))

(define (form-info info)
  (= record [])
  (= ctx (record-get 'ctx info))
  (unless (null? ctx)
    (record-set!
     'ctx (record-map form-type ctx)
     record))
  record)

(claim form-block (-> block? sexp?))

(define (form-block block)
  (match block
    ((cons-block info instrs)
     `(,info ,(list-map form-instr instrs)))))

(claim form-instr (-> instr? string?))

(define (form-instr instr)
  (cond ((general-instr? instr)
         (= [op args] instr)
         (string-append-many
          [(format-sexp op) " "
           (string-join ", " (list-map form-arg args))]))
        ((special-instr? instr)
         (match instr
           ((callq target arity)
            (string-append-many
             ["callq " (format-sexp target) ", " (format-sexp arity)]))
           (retq
            (string-append-many
             ["retq"]))
           ((jmp target)
            (string-append-many
             ["jmp " (format-sexp target)]))))))

(claim form-arg (-> arg? string?))

(define (form-arg arg)
  (match arg
    ((var-arg name)
     (format-sexp name))
    ((imm-arg value)
     (string-append "$" (format-sexp value)))
    ((reg-arg name)
     (string-append "%" (format-sexp name)))
    ((deref-arg name offset)
     (string-append-many
      [(format-sexp offset)
       "(" "%" (format-sexp name) ")"]))))
