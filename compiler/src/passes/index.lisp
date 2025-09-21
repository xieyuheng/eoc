;; The aim of a compiler is to bridge the differences between languages.
;; We translate the source language to the target language
;; by many passes, each deals with one difference.

(include "partial-eval.lisp"
  partial-eval-program)

(include "uniquify.lisp"
  ;; Dealing with the shadowing of variables by
  ;; renaming every variable (introduced by let)
  ;; to a unique name.
  uniquify)

(include "remove-complex-operands.lisp"
  ;; To ensure that each subexpression of a primitive operation
  ;; or function call is an atom (variable or integer).
  ;; We refer to non-atom exp as _complex_.
  ;; This pass introduces temporary variables
  ;; to hold the results of complex subexpressions.
  rco-program
  atom-operand-exp?)

(include "explicate-control.lisp"
  ;; To make the execution order of the program explicit.
  ;; It converts the abstract syntax tree representation into a graph
  ;; in which each node is a labeled sequence of statements
  ;; and the edges are goto statements.
  explicate-control)

(include "select-instructions.lisp"
  ;; To handle the difference between c statement and x86 instructions.
  ;; This pass converts each c statement to a short sequence of
  ;; instructions that accomplishes the same task.
  ;; The target language of this pass is a variant of x86
  ;; that still uses variables.
  select-instructions)

(include "uncover-live.lisp"
  ;; Do liveness analysis -- uncover which variables are in use
  ;; in different regions of a program.
  ;; A variable or register is _live_ at a program point if its
  ;; current value is used at some later point in the program.
  ;; This pass stores the result as list of sets
  ;; under `:live-before` and `:live-after` in block info.
  uncover-live)

(include "assign-homes.lisp"
  ;; To replace variables with registers or stack locations.
  assign-homes)

(include "patch-instructions.lisp"
  ;; This pass uses a reserved register (rax)
  ;; to fix x86 instructions with invalid arguments.
  ;; Since only one argument of an x86 instruction may be memory,
  ;; but assign-homes might assign both arguments to memory locations.
  patch-instructions)

(include "prolog-and-epilog.lisp"
  ;; This pass places the program instructions inside a `begin` function
  ;; with instructions for the prolog and epilog.
  prolog-and-epilog)
