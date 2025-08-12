#lang racket

(provide define-class)

(define-syntax define-class
  (syntax-rules ()
    ((_ class-name () s ...)
     (define class-name
       (class object%
         (super-new)
         s ...)))
    ((_ class-name (super-class) s ...)
     (define class-name
       (class super-class
         (super-new)
         s ...)))))
