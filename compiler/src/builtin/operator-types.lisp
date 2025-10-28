(import-all "deps")

(export operator-types)

(claim operator-types (record? arrow-type?))

(define operator-types
  [:iadd (arrow-type [int-type int-type] int-type)
   :isub (arrow-type [int-type int-type] int-type)
   :ineg (arrow-type [int-type] int-type)
   :imul (arrow-type [int-type int-type] int-type)
   :random-dice (arrow-type [] int-type)
   :and (arrow-type [bool-type bool-type] bool-type)
   :or (arrow-type [bool-type bool-type] bool-type)
   :not (arrow-type [bool-type] bool-type)
   ;; eq? is generic
   :lt? (arrow-type [int-type int-type] bool-type)
   :gt? (arrow-type [int-type int-type] bool-type)
   :lteq? (arrow-type [int-type int-type] bool-type)
   :gteq? (arrow-type [int-type int-type] bool-type)])
