;; To compile one language to another,
;; is to bridge the differences between the two languages.

;; We ease the challenge of compiling from s to x86
;; by breaking down the problem into several steps,
;; which deal with these differences one at a time.
;; Each of these steps is called a pass of the compiler.

(include "010-uniquify.lisp"
  ;; deals with the shadowing of variables
  ;; by renaming every variable to a unique name.
  uniquify)

(include "020-remove-complex-operands.lisp"
  ;; ensures that each subexpression of a primitive operation
  ;; or function call is a variable or integer,
  ;; that is, an _atomic_ expression.
  ;; We refer to nonatomic expressions as _complex_.
  ;; This pass introduces temporary variables to hold
  ;; the results of complex subexpressions.
  rco-program atom-operand-exp?)

(include "030-explicate-control.lisp"
  ;; makes the execution order of the program explicit.
  ;; It converts the abstract syntax tree representation into a graph
  ;; in which each node is a labeled sequence of statements
  ;; and the edges are `goto` statements.
  explicate-control)

(include "040-select-instructions.lisp"
  ;; handles the difference between s operations and x86
  ;; instructions. This pass converts each LVar operation to a short
  ;; sequence of instructions that accomplishes the same task.
  select-instructions)

(include "050-assign-homes.lisp"
  ;; replaces variables with registers or stack locations.
  assign-homes)

(include "060-patch-instructions.lisp"
  ;; uses a reserved register to fix invalid arguments problem.
  ;; recall that only one argument of an x86 instruction
  ;; may be a memory access, but assign-homes might be
  ;; forced to assign both arguments to memory locations.
  ;; TODO patch-instructions
  )


(include "070-prelude-and-conclusion.lisp"
  ;; places the program instructions inside a `main` function
  ;; with instructions for the prelude and conclusion.
  ;; TODO prelude-and-conclusion
  )
