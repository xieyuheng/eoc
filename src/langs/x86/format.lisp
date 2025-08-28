(import-all "index.lisp")

(claim format-program (-> program? sexp?))

(define (format-program program)
  (match program
    ((make-program info blocks)
     `(program ,info ,(record-map format-block blocks)))))

(claim format-block (-> block? sexp?))

(define (format-block block)
  (match block
    ((make-block info instrs)
     `(block ,info ,(list-map format-instr instrs)))))

(claim format-instr (-> instr? string?))

(define (format-instr instr)
  (cond ((general-instr? instr)
         (= [op args] instr)
         (string-append-many
          [(format-sexp op) " "
           (string-join ", " (list-map format-arg args))]))
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

(claim format-arg (-> arg? string?))

(define (format-arg arg)
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
