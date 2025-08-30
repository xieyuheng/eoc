(import-all "index.lisp")

(claim form-x86-program (-> x86-program? sexp?))

(define (form-x86-program x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     `(x86-program ,info ,(record-map form-block blocks)))))

(claim form-block (-> block? sexp?))

(define (form-block block)
  (match block
    ((cons-block info instrs)
     `(,info ,(list-map format-instr instrs)))))

(claim format-instr (-> instr? string?))

(define (format-instr instr)
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
    ((var name)
     (format-sexp name))
    ((imm value)
     (string-append "$" (format-sexp value)))
    ((reg name)
     (string-append "%" (format-sexp name)))
    ((deref name offset)
     (string-append-many
      [(format-sexp offset)
       "(" "%" (format-sexp name) ")"]))))
