# migrate passes

[pass] 020-remove-complex-operands.lisp -- fix `rco-atom` -- call `freshen`
[pass] 020-remove-complex-operands.snapshot.lisp

[pass] 030-explicate-control.lisp
[pass] 030-explicate-control.snapshot.lisp
[pass] 040-select-instructions.lisp
[pass] 040-select-instructions.snapshot.lisp
[pass] 050-assign-homes.lisp
[pass] 050-assign-homes.snapshot.lisp
[pass] 060-patch-instructions.lisp
[pass] 070-prelude-and-conclusion.lisp

# old

> 2 Integers and Variables

[lang] c-checker -- required by 050-assign-homes
[syntax] extract X86Info
[pass] 050-assign-homes
[pass] 050-assign-homes -- test
[pass] 060-patch-instructions
[pass] 070-prelude-and-conclusion

> 3 Register Allocation
> 4 Booleans and Conditionals
> 5 Loops and Dataflow Analysis
> 6 Tuples and Garbage Collection
> 7 Functions
> 8 Lexically Scoped Functions
> 9 Dynamic Typing
> 10 Gradual Typing
> 11 Generics
