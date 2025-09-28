(import-all "deps.lisp")
(import-all "index.lisp")

(export format-x86-program)

(define indentation "        ")

(define (indent-line line)
  (string-append-many [indentation line "\n"]))

(claim format-x86-program (-> x86-program? string?))

(define (format-x86-program x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (string-append-many
      (cons (indent-line ".global begin")
            (list-map format-block-entry
                      (record-entries blocks)))))))

(claim format-block-entry (-> (tau symbol? block?) sexp?))

(define (format-block-entry entry)
  (match entry
    ([label (cons-block info instrs)]
     (= label-string (string-append (symbol-to-string label) ":\n"))
     (string-append-many
      (cons label-string
            (list-map (compose indent-line format-instr)
                      instrs))))))

(claim format-instr (-> instr? string?))

(define (format-instr instr)
  (cond ((general-instr? instr)
         (= [op rands] instr)
         (string-append-many
          [(format-sexp op) " "
           (string-join ", " (list-map format-rand rands))]))
        ((special-instr? instr)
         (match instr
           ((callq target arity)
            (string-append-many
             ["callq " (format-sexp target)]))
           (retq
            (string-append-many
             ["retq"]))
           ((jmp target)
            (string-append-many
             ["jmp " (format-sexp target)]))))))

(claim format-rand (-> operand? string?))

(define (format-rand arg)
  (match arg
    ((var-rand name)
     (format-sexp name))
    ((imm-rand value)
     (string-append "$" (format-sexp value)))
    ((reg-rand name)
     (string-append "%" (format-sexp name)))
    ((deref-rand name offset)
     (string-append-many
      [(format-sexp offset)
       "(" "%" (format-sexp name) ")"]))))
