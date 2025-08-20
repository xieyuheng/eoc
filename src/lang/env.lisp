(define-data env?
  empty-env
  (cons-env (name symbol?) (value anything?) (rest env?)))

(claim env-lookup-value (-> env? symbol? anything?))

(define (env-lookup-value env name)
  (match env
    (empty-env null)
    ((cons-env key value rest)
     (if (equal? key name)
       value
       (env-lookup-value rest name)))))

(claim env-set-value (-> env? symbol? anything? env?))

(define (env-set-value env name value)
  (cons-env name value env))
