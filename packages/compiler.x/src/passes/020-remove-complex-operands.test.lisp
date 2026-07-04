(import-all "deps")
(import-all "020-remove-complex-operands")

(assert
  (typed-atom-operand-exp?
   (infer-exp [] (parse-exp '(iadd 1 1)))))

(assert-not
  (typed-atom-operand-exp?
   (infer-exp [] (parse-exp '(iadd (iadd 1 1) 1)))))

(assert
  (typed-atom-operand-exp?
   (infer-exp [] (parse-exp '(let ((y (iadd 1 1))) (iadd y 1))))))

(assert-not
  (typed-atom-operand-exp?
   (infer-exp [] (parse-exp '(let ((y (iadd (iadd 1 1) 1))) (iadd y 1))))))
