;; partial evaluation by normalization.
(include "partial-eval" partial-eval-program)

;; Consistently rename every variable (introduced by let) to a unique name.
(include "uniquify" uniquify)

;; Translate nested function applications to
;; assignments (let) of results to temporary variables.
(include "remove-complex-operands" rco-program atom-operand-exp?)

;; Translate s to c with explicit execution order.
(include "explicate-control" explicate-control)

;; Translate c to x86 (with variables).
(include "select-instructions" select-instructions)

;; Do liveness analysis for each block, i.e. uncover
;; which variables are in use for every instruction.
(include "uncover-live" uncover-live)

;; Build interference graph for each block.
(include "build-interference" build-interference)

;; Replace variables by registers or stack locations.
(include "allocate-registers" allocate-registers)

;; Fix pseudo x86 instructions and remove self moves.
(include "patch-instructions" patch-instructions)

;; Add prolog and epilog to each function (currently only one).
(include "prolog-and-epilog" prolog-and-epilog)
