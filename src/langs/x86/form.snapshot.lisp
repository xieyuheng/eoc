(import-all "index.lisp")

(form-program
 (make-program
  []
  [:start
   (make-block
    []
    [['movq [(deref 'rax 10) (reg 'rax)]]
     ['movq [(reg 'rax) (reg 'rax)]]
     (callq 'f 2)
     retq])]))
