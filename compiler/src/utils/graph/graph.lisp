;; undirected simple graph

(export
  graph? @graph
  new-graph)

(define-data (graph? V)
  (@graph (vertices (set? V))
          (neighbor-hash (hash? V (set? V)))))

(claim new-graph
  (-> (graph? anything?)))

(define (new-graph)
  (= vertices (@set))
  (= neighbor-hash (@hash))
  (@graph vertices neighbor-hash))
