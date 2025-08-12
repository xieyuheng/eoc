#lang racket

(require rackunit)

(provide assert-equal)

(define-syntax assert-equal
  (syntax-rules ()
    ((_ x y)
     (check-equal? x y))))

(provide assert)

(define-syntax assert
  (syntax-rules ()
    ((_ x)
     (check-not-false x))))
