#lang racket

(provide string-to-subscript)

(define (string-to-subscript string)
  (list->string (map char-to-subscript (string->list string))))

(define (char-to-subscript char)
  (match char
    [#\0 #\₀]
    [#\1 #\₁]
    [#\2 #\₂]
    [#\3 #\₃]
    [#\4 #\₄]
    [#\5 #\₅]
    [#\6 #\₆]
    [#\7 #\₇]
    [#\8 #\₈]
    [#\9 #\₉]
    [_ char]))
