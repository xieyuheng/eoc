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

;; (claim check-exp (-> env? exp? (pair? exp? type?)))

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
