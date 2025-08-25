(import-all "index.lisp")

(define operator-types
  [:+ [[int-t int-t] int-t]
   :- [[int-t int-t] int-t]])

(claim type-equal? (-> type? type? bool?))

(define (type-equal? lhs rhs) (equal? lhs rhs))

(claim check-type-equal? (-> type? type? exp? void?))

(define (check-type-equal? lhs rhs exp)
  (if (type-equal? lhs rhs)
    void
    (exit [:message "(check-type-equal?) fail"
           :lhs lhs :rhs rhs :exp exp])))

;; (claim check-op (-> op-t (list-t type-t) exp-t type-t))

;; (define (check-op op arg-types exp)
;;   (match-define (cons expected-arg-types return-type)
;;                 (alist-get-or-fail (operator-types) op))
;;   (for ((arg-type arg-types)
;;         (expected-arg-type expected-arg-types))
;;        (check-type-equal? arg-type expected-arg-type exp))
;;   return-type)

;; (claim check-exp (-> env-t exp-t (pair-t exp-t type-t)))

;; (define ((check-exp env) exp)
;;   (match exp
;;     ((Var name)
;;      (cons (Var name) (alist-get-or-fail env name)))
;;     ((Int value)
;;      (cons (Int value) 'Integer))
;;     ((Prim op args)
;;      (define arg-pairs (map (check-exp env) args))
;;      (define args^ (map car arg-pairs))
;;      (define types (map cdr arg-pairs))
;;      (cons (Prim op args^) (check-op op types exp)))
;;     ((Let name rhs body)
;;      (match-define (cons rhs^ rhs-type)
;;                    ((check-exp env) rhs))
;;      (match-define (cons body^ body-type)
;;                    ((check-exp (alist-set env name rhs-type)) body))
;;      (cons (Let name rhs^ body^) body-type))))

;; (define (check-program program)
;;   (match program
;;     ((Program info body)
;;      (match-define (cons body^ t)
;;                    ((check-exp '()) body))
;;      (check-type-equal? t 'Integer body)
;;      (Program info body^))))
