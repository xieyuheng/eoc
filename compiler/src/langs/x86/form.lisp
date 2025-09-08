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

(claim form-instr (-> instr? sexp?))

(define (form-instr instr)
  (cond ((general-instr? instr)
         (= [op args] instr)
         (cons op (list-map form-arg args)))
        ((special-instr? instr)
         (match instr
           ((callq target arity)
            ['callq target arity])
           (retq
            ['retq])
           ((jmp target)
            ['jmp target])))))

(claim form-arg (-> arg? sexp?))

(define (form-arg arg)
  (match arg
    ((var-arg name)
     name)
    ((imm-arg value)
     (string-to-symbol (string-append "$" (format-sexp value))))
    ((reg-arg name)
     (string-to-symbol (string-append "%" (format-sexp name))))
    ((deref-arg name offset)
     (= reg-name (string-to-symbol (string-append "%" (format-sexp name))))
     ['deref reg-name offset])))
