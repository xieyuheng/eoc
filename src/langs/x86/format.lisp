(import-all "index.lisp")

;; (claim format-program (-> program? sexp?))

;; (define (format-program program)
;;   (match program
;;     ((make-program info blocks)
;;      `(program ,info ,(alist-map-value blocks format-block)))))

;; (claim format-block (-> block? sexp?))

;; (define (format-block block)
;;   (match block
;;     ((Block info instr*)
;;      `(block ,info ,(map format-instr instr*)))))

;; (claim format-instr (-> instr? (list? string?)))

;; (define (format-instr instr)
;;   (list (format-instr-string instr)))

;; (claim format-instr-string (-> instr? string?))

;; (define (format-instr-string instr)
;;   (match instr
;;     ((Instr name arg*)
;;      (~a #:separator " "
;;          name (apply ~a #:separator ", " (map format-arg arg*))))
;;     ((Callq target arity)
;;      (~a #:separator " "
;;          "callq" (~a #:separator ", " target arity)))
;;     ((Retq)
;;      (~a #:separator " "
;;          "retq"))
;;     ((Jmp target)
;;      (~a #:separator " "
;;          "jmp" target))))

;; (claim format-arg (-> arg? string?))

;; (define (format-arg arg)
;;   (match arg
;;     ((Var name)
;;      (~a name))
;;     ((Imm value)
;;      (~a "$" value))
;;     ((Reg name)
;;      (~a "%" name))
;;     ((Deref reg offset)
;;      (~a offset "(" "%" reg ")"))))
