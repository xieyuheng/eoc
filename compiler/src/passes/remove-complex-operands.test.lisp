(import-all "deps.lisp")
(import-all "index.lisp")

(assert
  (atomic-operand-exp?
   (parse-exp '(iadd x 1))))

(assert-not
  (atomic-operand-exp?
   (parse-exp '(iadd (iadd x 1) 1))))

(assert
  (atomic-operand-exp?
   (parse-exp '(let ((y (iadd x 1))) (iadd y 1)))))

(assert-not
  (atomic-operand-exp?
   (parse-exp '(let ((y (iadd (iadd x 1) 1))) (iadd y 1)))))
