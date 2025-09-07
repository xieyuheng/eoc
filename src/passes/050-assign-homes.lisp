(import-all "deps.lisp")

(export assign-homes)

(claim assign-homes
  (-> (x86-program-with?
       (tau :locals-types (record? type?)))
      x86-program?))

(define (assign-homes x86-program)
  x86-program
  ;; (match x86-program
  ;;   ((cons-x86-program info blocks)
  ;;    (cons-x86-program
  ;;     ;; [[:stack-space (calc-stack-space (cdr (car info)))]]
  ;;     info
  ;;     (record-map (assign-homes-block 'TODO) blocks))))
  )

;; ;; (define (calc-stack-space ls) (* 8 (length ls)))

;; (define (assign-homes-block ls block)
;;   (match b
;;     [(Block info es)
;;      (Block info (for/list ([e es]) (assign-homes-instr e ls)))]
;;     ))

;; (define (find-index v ls)
;;   (cond
;;    ;;[(eq? v (Var-name (car ls))) 1]
;;    [(eq? v (car ls)) 1]
;;    [else (add1 (find-index v (cdr ls)))]
;;    ))

;; (define (assign-homes-imm i ls)
;;   (match i
;;     [(Reg reg) (Reg reg)]
;;     [(Imm int) (Imm int)]
;;     [(Var v) (Deref 'rbp (* -8 (find-index v (cdr ls))))]
;;     ))

;; (define (assign-homes-instr i ls)
;;   (match i
;;     [(Instr op (list e1))
;;      (Instr op (list (assign-homes-imm e1 ls)))]
;;     [(Instr op (list e1 e2))
;;      (Instr op (list (assign-homes-imm e1 ls) (assign-homes-imm e2 ls)))]
;;     [else i]
;;     ))
