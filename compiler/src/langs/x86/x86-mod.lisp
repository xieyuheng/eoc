(import-all "instr")

(export
  x86-mod? cons-x86-mod
  x86-mod/info?
  x86-mod/block?
  block? cons-block
  block-info
  block-instrs
  block/info?)

(define-data x86-mod?
  (cons-x86-mod
   (info anything?)
   (blocks (record? block?))))

(claim x86-mod/info?
  (-> (-> anything? bool?) x86-mod?
      bool?))

(define (x86-mod/info? info-p x86-mod)
  (info-p (cons-x86-mod-info x86-mod)))

(claim x86-mod/block?
  (-> (-> block? bool?) x86-mod?
      bool?))

(define (x86-mod/block? block-p x86-mod)
  (list-all?
   block-p
   (record-values (cons-x86-mod-blocks x86-mod))))

(define-data block?
  (cons-block
   (info anything?)
   (instrs (list? instr?))))

(define block-info cons-block-info)
(define block-instrs cons-block-instrs)

(claim block/info?
  (-> (-> anything? bool?) block?
      bool?))

(define (block/info? info-p block)
  (info-p (cons-block-info block)))
