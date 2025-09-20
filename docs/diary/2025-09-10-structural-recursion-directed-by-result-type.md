---
title: structural recursion directed by result type
date: 2025-09-10
---

之前在回顾 remove-complex-operands 这个 pass 的代码的时候，
我发现自己没能认出来 writer monad，
这代表我对 functional programming 的理解还不充分。

今天在看 jeremy siek 2020 年的编译器课程视频，
又回顾了 remove-complex-operands 和 explicate-control 的代码，
发现我对 structural recursion 的理解也不充分。

# explicate-control

之前我把 explicate-control 的代码写成了这样：

```scheme
(import-all "deps.lisp")
(import "remove-complex-operands.lisp" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((@program info body)
     (@c-program info [:start (explicate-tail body)]))))

;; `explicate-tail` -- explicate an exp at tail position.
;;   thus this structural recursion is directed
;;   by the shape of input exp.

(claim explicate-tail (-> atom-operand-exp? seq?))

(define (explicate-tail exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-tail body)))
    (_
     (return-seq (to-c-exp exp)))))

(claim to-c-exp
  (-> (inter atom-operand-exp? (negate let-exp?))
      c-exp?))

(define (to-c-exp exp)
  (match exp
    ((var-exp name)
     (var-c-exp name))
    ((int-exp n)
     (int-c-exp n))
    ((prim-exp op args)
     (prim-c-exp op (list-map to-c-exp args)))))
```

重点是 `explicate-assign`：

```scheme
(claim explicate-assign
  (-> symbol? atom-operand-exp? seq? seq?))

;; The third parameter is called `continuation` because it contains
;; the generated code that should come after the current assignment.

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     ;; `rhs-body` is not at tail position,
     ;; but we temporarily view it as so,
     ;; and call `explicate-tail` on it,
     ;; the result will be prepend to the real continuation.
     (= continuation (prepend-assign name (explicate-tail rhs-body) continuation))
     (explicate-assign rhs-name rhs-rhs continuation))
    (_
     (= stmt (assign-stmt (var-c-exp name) (to-c-exp rhs)))
     (cons-seq stmt continuation))))

(claim prepend-assign (-> symbol? seq? seq? seq?))

(define (prepend-assign top-result-name top-seq bottom-seq)
  (match top-seq
    ((return-seq exp)
     (= stmt (assign-stmt (var-c-exp top-result-name) exp))
     (cons-seq stmt bottom-seq))
    ((cons-seq stmt top-next-seq)
     (cons-seq stmt (prepend-assign top-result-name top-next-seq bottom-seq)))))
```

我给 `explicate-assign` 写了一大段注释，
解释为什么要调用 `explicate-tail`，
但是其实并不应该调用 `explicate-tail`，
也不需要 `prepend-assign`，
应该写成这样：

```scheme
(claim explicate-assign
  (-> symbol? atom-operand-exp? seq? seq?))

;; `explicate-assign` -- explicate an assignment
;;   by accumulating a continuation parameter,
;;   The third parameter is called "continuation"
;;   because it contains the generated code that
;;   should come after the current assignment.

;; example:
;;
;;     > x (let ((y (ineg 42))) y) (return (ineg x))
;;     = [(= y (ineg 42))
;;        (= x y)
;;        (return (ineg x)]

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     (= continuation (explicate-assign name rhs-body continuation))
     (explicate-assign rhs-name rhs-rhs continuation))
    (_
     (= stmt (assign-stmt (var-c-exp name) (to-c-exp rhs)))
     (cons-seq stmt continuation))))
```

# remove-complex-operands

新的 remove-complex-operands 代码写成了这样：

```scheme
(import-all "deps.lisp")

(export rco-program atom-operand-exp?)

(claim rco-program (-> program? program?))

(define (rco-program program)
  (match program
    ((@program info body)
     (= state [:count 0])
     (@program info (rco-exp state body)))))

(define state? (tau :count int-non-negative?))

(claim freshen (-> state? symbol? symbol?))

(define (freshen state name)
  (= count (record-get 'count state))
  (record-put! 'count (iadd 1 count) state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

;; `atom-operand-exp?` -- defines the grammer of the result exp of `rco-exp`.
;;   this grammer will direct (by result type) the implementation
;;   of structural recursive functions -- `rco-exp` and `rco-atom`.

(claim atom-operand-exp? (-> exp? bool?))

(define (atom-operand-exp? exp)
  (match exp
    ((var-exp name)
     true)
    ((int-exp n)
     true)
    ((let-exp name rhs body)
     (and (atom-operand-exp? rhs)
          (atom-operand-exp? body)))
    ((prim-exp op args)
     (list-all? atom-exp? args))))

;; `rco-exp` -- making the operand position of an exp atomic.

;; the bind of the inner arg should be cons-ed at the out side.
;; for example:
;;
;;     > (iadd (iadd 1 2) (iadd 3 (iadd 4 5)))
;;     = (let ((_₁ (iadd 1 2)))
;;         (let ((_₂ (iadd 4 5)))
;;           (let ((_₃ (iadd 3 _₂)))
;;             (iadd _₁ _₃))))

(claim rco-exp (-> state? exp? atom-operand-exp?))

(define (rco-exp state exp)
  (match exp
    ((var-exp name)
     (var-exp name))
    ((int-exp n)
     (int-exp n))
    ((let-exp name rhs body)
     (let-exp name (rco-exp state rhs) (rco-exp state body)))
    ((prim-exp op args)
     (= [binds new-args] (rco-atom-many state args))
     (prepend-lets binds (prim-exp op new-args)))))

(define bind? (tau symbol? atom-operand-exp?))

(claim prepend-lets
  (-> (list? bind?) exp? exp?))

(define (prepend-lets binds exp)
  (match binds
    ([]
     exp)
    ((cons [name rhs] rest-binds)
     (let-exp name rhs (prepend-lets rest-binds exp)))))

;; `rco-atom` -- making an exp atomic.

;; for example:
;;
;;     > (iadd 3 (iadd 4 5))
;;     = [[[_₂ (iadd 4 5)]
;;         [_₃ (iadd 3 _₂)]]
;;        _₃]

;; TODO `rco-atom` and `rco-atom-many` use writer monad,
;; we should make this explicit.

;; TODO we should also avoid side effect on state
;; by using state monad.

(claim rco-atom
  (-> state? exp?
      (tau (list? bind?)
           atom-operand-exp?)))

(define (rco-atom state exp)
  (match exp
    ((var-exp name)
     [[] (var-exp name)])
    ((int-exp n)
     [[] (int-exp n)])
    ((let-exp name rhs body)
     (= [binds new-body] (rco-atom state body))
     ;; use `rco-exp` instead of `rco-atom` on `rhs`,
     ;; `rco-atom` should only be used on exp at the operand position.
     [(cons [name (rco-exp state rhs)] binds)
      new-body])
    ((prim-exp op args)
     (= [binds new-args] (rco-atom-many state args))
     (= name (freshen state '_))
     [(list-push [name (prim-exp op new-args)] binds)
      (var-exp name)])))

(claim rco-atom-many
  (-> state? (list? exp?)
      (tau (list? bind?)
           (list? atom-operand-exp?))))

(define (rco-atom-many state exps)
  (= [binds-list new-exps] (list-unzip (list-map (rco-atom state) exps)))
  [(list-append-many binds-list) new-exps])
```

# structural recursion directed by result type

`rco-exp` 和 `rco-atom` 是我清晰认识到的第一个例子，
其 structural recursion 是 directed by result type 的，
而不是 directed by input type 的。

在一般讨论 structural recursion 的过程中，
人们经常说，递归的对象的类型如何递归定义，
递归函数就按照其定义来分 sum type 讨论。

然而这只是最基础的第一层。

比如这里 `atom-operand-exp?` 其实是对返回类型的递归定义，
所定义的返回类型是 `exp?` 的子集。

注意，下面的 grammer 是对 AST 而言的（而不是对具体语法而言的）。

```bnf
<atom-operand-exp>
  ::= (var-exp <symbol>)
    | (int-exp <int>)
    | (let-exp <symbol>
        <atom-operand-exp>
        <atom-operand-exp>)
    | (prim-exp <op> [<atom-exp> ...])
```

此时 structural recursion 是按照这个返回类型的递归定义来写的。

注意，因为是在动态语言里，所以「类型」就等价于谓词所定义的子集。

`explicate-control` 中的两个递归函数
`explicate-tail` 和 `explicate-assign` 也是类似的。
此时不是按照返回值的类型，也不是简单的按照递归对象的类型，
而是可以重新递归定义一个集合来刻画递归对象的类型，
区分处理 tail position 和 non-tail position。

此时递归对象的集合不是 `<exp>`，
而是上一个 pass 的结果 `<atom-operand-exe>`，
对其再次划分：

```bnf
<atom-operand-exe> ::= <tail-exp>
<tail-exp>
  ::= (var-exp <symbol>)
    | (int-exp <int>)
    | (prim-exp <op> [<atom-exp> ...])
    | (let-exp <symbol>
        <non-tail-exp>
        <tail-exp>)
<non-tail-exp>
  ::= (var-exp <symbol>)
    | (int-exp <int>)
    | (prim-exp <op> [<atom-exp> ...])
    | (let-exp <symbol>
        <non-tail-exp>
        <non-tail-exp>)
```

此时再严格地按照 structural recursion 来写，
就会发现 `explicate-assign` 根本就应该调用 `explicate-tail`。

# 总结

这是我首次意识到，
可以通过递归刻画 target type 和 result type 的子集，
来实现结构清晰的 structural recursion。

这对于写编译器尤其重要，
因为编译器在于 bridging differences，
而清晰地把 differences 表达出来，
就需要这种对 target type 和 result type 的递归刻画。

现在知道这种技巧了，
再读别的递归函数时（比如 EOPL 中的递归函数时），
就可以注意一下是否可以做这种递归刻画。

# 动态类型之重要

在 x-lisp 中（或者一般地，在动态类型语言中），
定义数据类型的谓词和用来刻画子集的谓词，属于平级的 object。
而在静态类型语言中，定义数据类型用的是 type，
用来刻画子集的是谓词，二者不是一类 object。
可能这就是我之前没能认识到这种 pattern 的原因。

注意，就算是增强类型系统的表达能力，使用 dependent type，
也没法做到像使用谓词一样自由地刻画子集。
所以动态类型语言有其集合论意义上的独特的重要性。
