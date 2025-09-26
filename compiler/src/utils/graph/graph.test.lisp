(import-all "index.lisp")

(begin
  (= graph (new-graph))
  (graph-add-vertex! 1 graph)
  (graph-add-vertex! 2 graph)
  (graph-add-vertex! 3 graph)
  (graph-add-edge! 1 2 graph)
  (graph-add-edge! 2 3 graph)
  (graph-add-edge! 3 1 graph)
  graph)
