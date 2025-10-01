(import-all "deps")
(import-all "remove-complex-operands")

(assert
  (atom-operand-exp?
   (parse-exp '(iadd x 1))))

(assert-not
  (atom-operand-exp?
   (parse-exp '(iadd (iadd x 1) 1))))

(assert
  (atom-operand-exp?
   (parse-exp '(let ((y (iadd x 1))) (iadd y 1)))))

(assert-not
  (atom-operand-exp?
   (parse-exp '(let ((y (iadd (iadd x 1) 1))) (iadd y 1)))))
