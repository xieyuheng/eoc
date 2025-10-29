(let ((x (begin
           (print-int 1)
           (newline)
           (print-int 2)
           (newline)
           (print-int 3)
           (newline)
           6)))
  (iadd x x))
