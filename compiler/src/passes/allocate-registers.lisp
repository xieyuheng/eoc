(import-all "deps")
(import "build-interference" interference-info?)

(export allocate-registers)

(claim assign-homes
  (-> (x86-program/block?
       (block/info? interference-info?))
      x86-program?))

(define (allocate-registers x86-program)
  x86-program)
