(import-all "deps.lisp")
(import-all "index.lisp")

(form-x86-program
 (cons-x86-program
  []
  [:start
   (cons-block
    []
    [['movq [(deref-rand 'rax 10) (reg-rand 'rax)]]
     ['movq [(reg-rand 'rax) (reg-rand 'rax)]]
     (callq 'f 2)
     retq])]))
