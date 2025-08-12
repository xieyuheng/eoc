#lang racket

(provide note)

(define-syntax note
  (syntax-rules ()
    ((_ x ...)
     (void))))
