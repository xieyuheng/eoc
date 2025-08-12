#lang racket

(require "string.rkt")

(provide freshen)

(define name-count 0)

(define (freshen name)
  (set! name-count (+ name-count 1))
  (string->symbol
   (string-append
    (symbol->string name)
    (string-to-subscript (~a name-count)))))
