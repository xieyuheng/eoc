;; undirected simple graph

(define-data (graph? V)
  (@graph (neighbor-hash (hash? V (set? V)))))
