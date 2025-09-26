;; undirected simple graph

(export
  graph? @graph new-graph
  graph-add-vertex!)

(define-data (graph? V)
  (@graph (vertices (set? V))
          (neighbor-hash (hash? V (set? V)))))

(claim new-graph
  (-> (graph? anything?)))

(define (new-graph)
  (= vertices (@set))
  (= neighbor-hash (@hash))
  (@graph vertices neighbor-hash))

(claim graph-add-vertex!
  (-> anything? (graph? anything?)
      (graph? anything?)))

(define (graph-add-vertex! vertex graph)
  (set-add! vertex (@graph-vertices graph)))
