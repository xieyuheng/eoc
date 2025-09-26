;; undirected simple graph

(export
  graph? @graph new-graph
  graph-vertices graph-neighbors
  graph-add-vertex!
  graph-add-edge!)

(define-data (graph? V)
  (@graph (vertices (set? V))
          (neighbor-hash (hash? V (set? V)))))

(claim new-graph
  (-> (graph? anything?)))

(define (new-graph)
  (= vertices (@set))
  (= neighbor-hash (@hash))
  (@graph vertices neighbor-hash))

(claim graph-vertices
  (-> (graph? anything?)
      (set? anything?)))

(define (graph-vertices graph)
  (@graph-vertices graph))

(claim graph-neighbors
  (-> anything? (graph? anything?)
      (set? anything?)))

(define (graph-neighbors vertex graph)
  (hash-get vertex (@graph-neighbor-hash graph)))

(claim graph-add-vertex!
  (-> anything? (graph? anything?)
      (graph? anything?)))

(define (graph-add-vertex! vertex graph)
  (set-add! vertex (@graph-vertices graph)))

(claim graph-add-edge!
  (-> anything? anything? (graph? anything?)
      (graph? anything?)))

(define (graph-add-edge! source target graph)
  (graph-add-vertex! source graph)
  (graph-add-vertex! target graph)
  (= neighbor-hash (@graph-neighbor-hash graph))
  (= source-neighbors (hash-get source neighbor-hash))
  (if (null? source-neighbors)
    (hash-put! source {target} neighbor-hash)
    (set-add! target source-neighbors))
  (= target-neighbors (hash-get target neighbor-hash))
  (if (null? target-neighbors)
    (hash-put! target {source} neighbor-hash)
    (set-add! source target-neighbors))
  graph)
