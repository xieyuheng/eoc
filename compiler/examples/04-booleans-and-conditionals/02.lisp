(let ((x (random-dice)))
  (let ((y (random-dice)))
    (iadd
     (if (if (lt? x 1) (eq? x 0) (eq? x 2))
       (iadd y 2)
       (iadd y 10))
     (if (if (lt? x 1) (eq? x 0) (eq? x 2))
       (iadd y 2)
       (iadd y 10)))))
