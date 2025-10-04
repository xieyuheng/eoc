;; partial evaluation by normalization.
(include "001-partial-eval" partial-eval-program)
;; Consistently rename every variable (introduced by let) to a unique name.
(include "010-uniquify" uniquify)
;; Translate nested function applications to
;; assignments (let) of results to temporary variables.
(include "020-remove-complex-operands" rco-program atom-operand-exp?)
;; Translate s to c with explicit execution order.
(include "030-explicate-control" explicate-control)
;; Translate c to x86 (with variables).
(include "040-select-instructions" select-instructions)
;; Do liveness analysis for each block, i.e. uncover
;; which variables are in use for every instruction.
(include "050-uncover-live" uncover-live)
;; Build interference graph for each block.
(include "051-build-interference" build-interference)
;; Replace variables by registers or stack locations.
(include "052-allocate-registers" allocate-registers)
;; Fix pseudo x86 instructions and remove self moves.
(include "060-patch-instructions" patch-instructions)
;; Add prolog and epilog to each function (currently only one).
(include "070-prolog-and-epilog" prolog-and-epilog)
