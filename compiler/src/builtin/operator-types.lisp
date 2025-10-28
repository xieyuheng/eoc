(import-all "deps")

(export operator-types)

(claim operator-types (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-type int-type] int-type]
   :isub [[int-type int-type] int-type]
   :ineg [[int-type] int-type]
   :imul [[int-type int-type] int-type]
   :random-dice [[] int-type]
   :and [[bool-type bool-type] bool-type]
   :or [[bool-type bool-type] bool-type]
   :not [[bool-type] bool-type]
   ;; eq? is generic
   :lt? [[int-type int-type] bool-type]
   :gt? [[int-type int-type] bool-type]
   :lteq? [[int-type int-type] bool-type]
   :gteq? [[int-type int-type] bool-type]])
