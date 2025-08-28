(import-all "index.lisp")

(format-program
 (make-program
  []
  [:start
   (make-block
    []
    [['movq [(reg 'rax) (reg 'rax)]]
     (callq 'f 2)
     retq])]))
