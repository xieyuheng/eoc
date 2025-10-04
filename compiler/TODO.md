update x-lisp for `hash-from-map`

# learn

> 4 Booleans and Conditionals

[s] add `bool-exp` and `if-exp`, add `bool?` to `value?`
[s] add and- or- not- exp
[s] eq? lt? gteq? lteq? gt? -- as new operator
[s] `eval` -- support conditional exps
[s] extract `eval-op`

> 5 Loops and Dataflow Analysis
> 6 Tuples and Garbage Collection
> 7 Functions
> 8 Lexically Scoped Functions
> 9 Dynamic Typing
> 10 Gradual Typing
> 11 Generics

# later

fix `uncover-live-write` & `uncover-live-read` -- on `(jmp label)`

- currently assume all jump is to `.epilog`

# improve

> Change x-lisp to improve the following code.

[builtin] improve `check-op` -- [maybe] by optional monad

# later

update x-lisp for `pretty-print` -- use `pretty-print` in `log-x86-program`
