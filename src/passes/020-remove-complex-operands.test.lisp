(import-all "deps.lisp")
(import-all "index.lisp")

(assert
  (atom-operand-exp?
   (parse-exp '(+ x 1))))

(assert-not
  (atom-operand-exp?
   (parse-exp '(+ (+ x 1) 1))))

(assert
  (atom-operand-exp?
   (parse-exp '(let ((y (+ x 1))) (+ y 1)))))
