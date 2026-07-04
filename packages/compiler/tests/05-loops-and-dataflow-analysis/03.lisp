(if (begin
      (print-int 1)
      (newline)
      (print-int 2)
      (newline)
      (print-int 3)
      (newline)
      (eq? 1 2))
  (begin
    (print-int 111)
    (newline)
    (eq? 1 2))
  (begin
    (print-int 222)
    (newline)
    (eq? 1 2)))
