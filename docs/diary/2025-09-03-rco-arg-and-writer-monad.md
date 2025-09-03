---
title: rco-arg and writer monad
date: 2025-09-03
---

`rco-arg` 用的其实是 writer monad，
但是我没能在第一时间看出来。

```scheme
(claim rco-args
  (-> state? (list? exp?)
      (tau (list? exp?)
           (list? (tau symbol? exp?)))))

(define (rco-args state args)
  (= [new-args bindings-list] (list-unzip (list-map (rco-arg state) args)))
  [new-args (list-append-many bindings-list)])

(claim rco-arg
  (-> state? exp?
      (tau exp?
           (list? (tau symbol? exp?)))))

(define (rco-arg state arg)
  (match arg
    ((var-exp name)
     [(var-exp name) []])
    ((int-exp n)
     [(int-exp n) []])
    ((let-exp name rhs body)
     (= [new-body bindings] (rco-arg state body))
     [new-body
      (cons [name (rco-exp state rhs)] bindings)])
    ((prim-exp op args)
     (= [new-args bindings] (rco-args state args))
     (= name (freshen state '_))
     [(var-exp name)
      (cons [name (prim-exp op new-args)] bindings)])))
```

这说明我对函数式编程其实还知识学了皮毛，
真的学会函数式编程，需要熟知这些常用的 monad。
