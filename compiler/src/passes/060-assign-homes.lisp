(import-all "deps")

(export assign-homes home-info?)

(define home-info?
  (tau :home-locations (hash? var-rand? location-operand?)))

(claim assign-homes
  (-> (x86-program/block? (block/info? home-info?))
      x86-program?))

(define (assign-homes x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info
      (record-map-value assign-homes-block blocks)))))

(claim assign-homes-block (-> block? block?))

(define (assign-homes-block block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-map (assign-homes-instr info) instrs)))))

(claim assign-homes-instr
  (-> home-info? instr?
      instr?))

(define (assign-homes-instr info instr)
  (cond ((special-instr? instr) instr)
        ((general-instr? instr)
         (= [op rands] instr)
         [op (list-map (assign-homes-operand info) rands)])))

(claim assign-homes-operand
  (-> home-info? operand?
      operand?))

(define (assign-homes-operand info operand)
  (= [:home-locations home-locations] info)
  (if (var-rand? operand)
    (hash-get operand home-locations)
    operand))
