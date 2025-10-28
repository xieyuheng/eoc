(import-all "deps")

;; Replace variables by home locations.

(export assign-homes home-info?)

(define home-info?
  (tau :home-locations (hash? var-rand? location-operand?)))

(claim assign-homes
  (-> (x86-mod/info? home-info?)
      x86-mod?))

(define (assign-homes x86-mod)
  (match x86-mod
    ((cons-x86-mod info blocks)
     (= [:home-locations home-locations] info)
     (cons-x86-mod info
      (record-map-value (assign-homes-block home-locations) blocks)))))

(claim assign-homes-block
  (-> (hash? var-rand? location-operand?) block?
      block?))

(define (assign-homes-block home-locations block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-map (assign-homes-instr home-locations) instrs)))))

(claim assign-homes-instr
  (-> (hash? var-rand? location-operand?) instr?
      instr?))

(define (assign-homes-instr home-locations instr)
  (cond ((special-instr? instr) instr)
        ((general-instr? instr)
         (= [op rands] instr)
         [op (list-map (assign-homes-operand home-locations) rands)])))

(claim assign-homes-operand
  (-> (hash? var-rand? location-operand?) operand?
      operand?))

(define (assign-homes-operand home-locations operand)
  (if (var-rand? operand)
    (hash-get operand home-locations)
    operand))
