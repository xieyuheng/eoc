(import-all "index.lisp")

(begin
  (= graph (new-graph))
  (graph-add-vertex! 1 graph)
  (graph-add-vertex! 2 graph)
  (graph-add-vertex! 3 graph)
  graph)
