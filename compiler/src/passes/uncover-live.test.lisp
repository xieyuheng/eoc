(import-all "deps.lisp")
(import-all "index.lisp")
(import-all "uncover-live.lisp")

;; example:
;;
;;     |               {a} - {a} + {} = {}
;;   1 | movq $5, a
;;     |               {a} - {b} + {} = {a}
;;   2 | movq $30, b
;;     |               {c} - {c} + {a} = {a}
;;   3 | movq a, c
;;     |               {b, c} - {b} + {} = {c}
;;   4 | movq $10, b
;;     |               {} - {c} + {b, c} = {b, c}
;;   5 | addq b, c
;;     |               {}

(assert-equal
  [{}
   {(var-rand 'a)}
   {(var-rand 'a)}
   {(var-rand 'c)}
   {(var-rand 'b) (var-rand 'c)}
   {}]
  (uncover-live-before*
   [['movq [(imm-rand 5) (var-rand 'a)]]
    ['movq [(imm-rand 30) (var-rand 'b)]]
    ['movq [(var-rand 'a) (var-rand 'c)]]
    ['movq [(imm-rand 10) (var-rand 'b)]]
    ['addq [(var-rand 'b) (var-rand 'c)]]]
   {}))
