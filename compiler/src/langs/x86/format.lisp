(import-all "deps")
(import-all "index")

(export format-x86-program)

(define indentation "        ")

(define (indent-line line)
  (string-concat [indentation line "\n"]))

(claim format-x86-program (-> x86-program? string?))

(define (format-x86-program x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (string-concat
      (cons (indent-line ".global begin")
            (list-map format-block-entry
                      (record-entries blocks)))))))

(claim format-block-entry (-> (tau symbol? block?) sexp?))

(define (format-block-entry entry)
  (match entry
    ([label (cons-block info instrs)]
     (= label-string (string-append (symbol-to-string label) ":\n"))
     (string-concat
      (cons label-string
            (list-map (compose indent-line format-instr)
                      instrs))))))

(claim format-instr (-> instr? string?))

(define (format-instr instr)
  (cond ((general-instr? instr)
         (= [op rands] instr)
         (string-concat
          [(format-sexp op) " "
           (string-join ", " (list-map format-rand rands))]))
        ((special-instr? instr)
         (match instr
           ((callq target arity)
            (string-concat
             ["callq " (format-sexp target)]))
           (retq
            (string-concat
             ["retq"]))
           ((jmp label)
            (string-concat
             ["jmp " (format-sexp label)]))
           ((jmp-if cc label)
            (string-concat
             ["j" (format-sexp cc) " " (format-sexp label)]))
           ((set-if cc dest)
            (string-concat
             ["set" (format-sexp cc) " " (format-rand dest)]))))))

(claim format-rand (-> operand? string?))

(define (format-rand operand)
  (match operand
    ((var-rand name)
     (format-sexp name))
    ((imm-rand value)
     (string-append "$" (format-sexp value)))
    ((reg-rand name)
     (string-append "%" (format-sexp name)))
    ((byte-reg-rand name)
     (string-append "%" (format-sexp name)))
    ((deref-rand name offset)
     (string-concat
      [(format-sexp offset)
       "(" "%" (format-sexp name) ")"]))))
