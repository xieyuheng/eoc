#lang racket

(provide re-provide)

(define-syntax re-provide
  (syntax-rules ()
    ((_ path)
     (begin
       (require path)
       (provide (all-from-out path))))))
