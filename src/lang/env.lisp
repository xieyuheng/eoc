(define-data env?
  empty-env
  (cons-env (name symbol?) (value anything?) (rest env?)))

(claim env-lookup (-> symbol? env? anything?))

(define (env-lookup name env)
  (match env
    (empty-env null)
    ((cons-env key value rest)
     (if (equal? key name)
       value
       (env-lookup name rest)))))
