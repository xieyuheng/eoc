(import-all "deps.lisp")
(import-all "index.lisp")

(export format-x86-program)

(claim format-x86-program (-> x86-program? string?))

(define (format-x86-program x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (string-append-many
      (cons "        .global begin\n"
            (list-map format-block-entry
                      (record-entries blocks)))))))

(claim format-block-entry (-> (tau symbol? block?) sexp?))

(define (format-block-entry entry)
  (match entry
    ([label (cons-block info instrs)]
     (= label-string (string-append (symbol-to-string label) ":\n"))
     (string-append-many
      (cons label-string
            (list-map (compose indent-instr format-instr)
                      instrs))))))

(define (indent-instr instr-string)
  (string-append-many
   ["        " instr-string "\n"]))

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
