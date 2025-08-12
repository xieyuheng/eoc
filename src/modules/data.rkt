#lang racket

(provide define-data)

(define-syntax define-data
  (syntax-rules ()
    ((_ data-name field-names)
     (struct data-name field-names #:prefab))))
