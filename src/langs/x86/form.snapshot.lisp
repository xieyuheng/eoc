(import-all "index.lisp")

(form-x86-program
 (cons-x86-program
  []
  [:start
   (cons-block
    []
    [['movq [(deref 'rax 10) (reg 'rax)]]
     ['movq [(reg 'rax) (reg 'rax)]]
     (callq 'f 2)
     retq])]))
