(import-all "deps")

(export assign-homes)

(define home-info?
  (tau :home-locations (hash? reg-rand? location-operand?)))

(claim assign-homes
  (-> (x86-program/info? home-info?)
      x86-program?))

(define (assign-homes x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info
      (record-map (assign-homes-block info) blocks)))))

(claim assign-homes-block
  (-> home-info? block?
      block?))

(define (assign-homes-block info block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-map (assign-homes-instr info) instrs)))))

(claim assign-homes-instr
  (-> home-info? instr?
      instr?))

(define (assign-homes-instr info instr)
  (if (general-instr? instr)
    (begin
      (= [op rands] instr)
      [op (list-map (assign-homes-operand info) rands)])
    instr))

(claim assign-homes-operand
  (-> home-info? operand?
      operand?))

(define (assign-homes-operand info operand)
  (= [:home-locations home-locations] info)
  (if (reg-rand? operand)
    (hash-get operand home-locations)
    operand))
