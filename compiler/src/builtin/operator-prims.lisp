(import-all "deps")

(export operator-prims)

(claim operator-prims (record? (*-> value? value?)))

(define operator-prims
  [:iadd iadd
   :isub isub
   :ineg ineg
   :imul imul
   :random-dice (lambda () (iadd 1 (random-int 0 5)))
   ;; and is lazy
   ;; or is lazy
   :not not
   :eq? equal?
   :lt? int-less?
   :gt? int-greater?
   :lteq? int-less-equal?
   :gteq? int-greater-equal?
   :print-int print
   :newline newline])
