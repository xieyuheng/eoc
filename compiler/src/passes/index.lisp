;; To compile one language to another,
;; is to bridge the differences between the two languages.

;; We ease the challenge of compiling from s to x86
;; by breaking down the problem into several steps,
;; which deal with these differences one at a time.
;; Each of these steps is called a pass of the compiler.

(include "partial-eval.lisp"
  partial-eval-program)

(include "uniquify.lisp"
  ;; deals with the shadowing of variables
  ;; by renaming every variable to a unique name.
  uniquify)

(include "remove-complex-operands.lisp"
  ;; ensures that each subexpression of a primitive operation
  ;; or function call is a variable or integer,
  ;; that is, an _atomic_ expression.
  ;; We refer to nonatomic expressions as _complex_.
  ;; This pass introduces temporary variables to hold
  ;; the results of complex subexpressions.
  rco-program atomic-operand-exp?)

(include "explicate-control.lisp"
  ;; makes the execution order of the program explicit.
  ;; It converts the abstract syntax tree representation into a graph
  ;; in which each node is a labeled sequence of statements
  ;; and the edges are `goto` statements.
  explicate-control)

(include "select-instructions.lisp"
  ;; handles the difference between s operations and x86
  ;; instructions. This pass converts each LVar operation to a short
  ;; sequence of instructions that accomplishes the same task.
  select-instructions)

(include "uncover-live.lisp"
  ;; The `uncover-live` pass performs _liveness analysis_; that is, it
  ;; discovers which variables are in use in different regions of a
  ;; program. A variable or register is _live_ at a program point if its
  ;; current value is used at some later point in the program.
  ;; `uncover-live` stores the result as list of sets
  ;; under :live-before and :live-after of block info.
  uncover-live)

(include "assign-homes.lisp"
  ;; replaces variables with registers or stack locations.
  assign-homes)

(include "patch-instructions.lisp"
  ;; uses a reserved register to fix invalid arguments problem.
  ;; recall that only one argument of an x86 instruction
  ;; may be a memory access, but assign-homes might be
  ;; forced to assign both arguments to memory locations.
  patch-instructions)

(include "prolog-and-epilog.lisp"
  ;; places the program instructions inside a `begin` function
  ;; with instructions for the prolog and epilog.
  prolog-and-epilog)
