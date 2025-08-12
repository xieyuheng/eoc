#lang racket

(require "note.rkt")

(provide alist-map-value)

(note alist-map-value
      (nu (K V R)
        (-> (alist-t K V) (-> V R)
            (alist-t K R))))

(define (alist-map-value alist f)
  (map (match-lambda
         ((cons key value)
          (cons key (f value))))
       alist))

(provide alist-get)

(note alist-get (nu (K V D) (-> (alist-t K V) K D (union V D))))

(define (alist-get alist key default)
  (cond ((null? alist) default)
        ((equal? key (car (car alist))) (cdr (car alist)))
        (else (alist-get (cdr alist) key default))))

(provide alist-get-or-fail)

(note alist-get-or-fail (nu (K V) (-> (alist-t K V) K V)))

(define (alist-get-or-fail alist key)
  (cond ((null? alist) (error "(alist-get-or-fail) unknown key" key))
        ((equal? key (car (car alist))) (cdr (car alist)))
        (else (alist-get-or-fail (cdr alist) key))))

(provide alist-set)

(note alist-set (nu (K V) (-> (alist-t K V) K V (alist-t K V))))

(define (alist-set alist key value)
  (cond ((null? alist)
         (list (cons key value)))
        ((equal? key (car (car alist)))
         (cons (cons key value) (cdr alist)))
        (else
         (cons (car alist) (alist-set (cdr alist) key value)))))

(provide alist-cons)

(note alist-cons (nu (K V) (-> (alist-t K V) K V (alist-t K V))))

(define (alist-cons key value alist)
  (cons (cons key value) alist))
