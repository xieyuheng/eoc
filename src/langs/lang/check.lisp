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

(claim check-op (-> op? (list? type?) exp? type?))

(define (check-op op arg-types exp)
  (= entry (record-get op operator-types))
  (= expected-arg-types (list-first entry))
  (= return-type (list-second entry))
  (list-map
   (lambda (pair)
     (= expected-arg-type (list-first pair))
     (= arg-type (list-second pair))
     (check-type-equal? arg-type expected-arg-type exp))
   (list-zip expected-arg-types arg-types))
  return-type)

;; (claim check-exp (-> env? exp? (tau exp? type?)))

(define (check-exp env exp)
  (match exp
    ((var-exp name)
     (cons (var-exp name) (env-lookup name env)))
    ((int-exp value)
     (cons (int-exp value) int-t))
    ((prim-exp op args)
     (define arg-pairs (list-map (check-exp env) args))
     (define args^ (list-map car arg-pairs))
     (define types (list-map cdr arg-pairs))
     (cons (prim-exp op args^) (check-op op types exp)))
    ((let-exp name rhs body)
     (= rhs-entry (check-exp env rhs))
     (= rhs^ (list-first rhs-entry))
     (= rhs-type (list-second rhs-entry))
     (= body-entry (check-exp (cons-env name rhs-type env) body))
     (= body^ (list-first body-entry))
     (= body-type (list-second body-entry))
     (cons (let-exp name rhs^ body^) body-type))))

;; (define (check-program program)
;;   (match program
;;     ((Program info body)
;;      (match-define (cons body^ t)
;;                    ((check-exp '()) body))
;;      (check-type-equal? t 'Integer body)
;;      (Program info body^))))
