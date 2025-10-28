(export
  type?
  int-type
  bool-type
  void-type
  arrow-type)

(define-data type?
  int-type
  bool-type
  void-type
  (arrow-type (arg-types (list? type?)) (return-type type?)))
