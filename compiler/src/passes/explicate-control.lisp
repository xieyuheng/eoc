(import-all "deps.lisp")
(import "remove-complex-operands.lisp" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((@program info body)
     (@c-program info [:start (explicate-tail body)]))))

;; (explicate-tail)
;;
;;   explicate an exp at tail position.
;;   thus this structural recursion is directed
;;   by the shape of input exp.
;;
;; example:
;;
;;   > (let ((x (let ((y (ineg 42))) y))) (ineg x))
;;   = [(= y (ineg 42))
;;      (= x y)
;;      (return (ineg x)]

(claim explicate-tail (-> atom-operand-exp? seq?))

(define (explicate-tail exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-tail body)))
    (_
     (return-seq (to-c-exp exp)))))

(claim to-c-exp
  (-> (inter atom-operand-exp? (negate let-exp?))
      c-exp?))

(define (to-c-exp exp)
  (match exp
    ((var-exp name)
     (var-c-exp name))
    ((int-exp n)
     (int-c-exp n))
    ((prim-exp op args)
     (prim-c-exp op (list-map to-c-exp args)))))

;; (explicate-assign)
;;
;;   explicate an assignment
;;   by accumulating a continuation parameter,
;;   The third parameter is called "continuation"
;;   because it contains the generated code that
;;   should come after the current assignment.
;;
;; example:
;;
;;   > x (let ((y (ineg 42))) y) (return (ineg x))
;;   = [(= y (ineg 42))
;;      (= x y)
;;      (return (ineg x)]

(claim explicate-assign
  (-> symbol? atom-operand-exp? seq? seq?))

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     (= continuation (explicate-assign name rhs-body continuation))
     (explicate-assign rhs-name rhs-rhs continuation))
    (_
     (= stmt (assign-stmt (var-c-exp name) (to-c-exp rhs)))
     (cons-seq stmt continuation))))
