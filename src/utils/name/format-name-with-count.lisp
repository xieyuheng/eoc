(define (format-name-with-count name count)
  (string-to-symbol
   (string-append
    (format-sexp name)
    (string-to-subscript (format-sexp count)))))
