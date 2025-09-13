;; A running example for register allocation.

(let ((v 1))
  (let ((w 42))
    (let ((x (iadd v 7)))
      (let ((y x))
        (let ((z (iadd x w)))
          (iadd z (ineg y)))))))
