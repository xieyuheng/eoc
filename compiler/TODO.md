> 2.11 Challenge: Partial Evaluator for LVar

(compile-passes) take `optimization-level`

eoc commands take `:compile-program`

test script about `.O1.`

```
00.lisp

=>

00.lisp.exe*
00.lisp.exe.out
00.lisp.passes
00.lisp.s

=> :optimization-level 1

00.lisp.O1.exe*
00.lisp.O1.exe.out
00.lisp.O1.passes
00.lisp.O1.s
```

`partial-eval` -- handle the following case:

```
(+ 1 (+ (random-dice) 1))
=>
(+ 2 (random-dice))
```

> 3 Register Allocation
> 4 Booleans and Conditionals
> 5 Loops and Dataflow Analysis
> 6 Tuples and Garbage Collection
> 7 Functions
> 8 Lexically Scoped Functions
> 9 Dynamic Typing
> 10 Gradual Typing
> 11 Generics

# improve

> Change x-lisp to improve the following code.

[builtin] improve `check-op`
[c] & [x86] improve `form-info`
