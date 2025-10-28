;; Shrink the language to smaller language.
(include "005-shrink" shrink)
;; Consistently rename every variable (introduced by let) to a unique name.
(include "010-uniquify" uniquify)
;; Translate nested function applications to
;; assignments (let) of results to temporary variables.
(include "020-remove-complex-operands" rco-mod atom-operand-exp?)
;; Translate s to c with explicit execution order.
(include "030-explicate-control" explicate-control)
;; Translate c to x86 (with variables).
(include "040-select-instructions" select-instructions)
;; Do liveness analysis for each block, i.e. uncover
;; which variables are in use for every instruction.
(include "050-uncover-live" uncover-live)
;; Build interference graph for each function.
(include "051-build-interference" build-interference)
;; Find home locations (hopefully registers) for variables.
(include "052-allocate-registers" allocate-registers)
;; Replace variables by home locations.
(include "060-assign-homes" assign-homes)
;; Fix pseudo x86 instructions and remove self moves.
(include "070-patch-instructions" patch-instructions)
;; Add prolog and epilog to each function (currently only one).
(include "080-prolog-and-epilog" prolog-and-epilog)
