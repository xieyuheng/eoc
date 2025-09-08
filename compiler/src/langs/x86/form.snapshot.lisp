(import-all "deps.lisp")
(import-all "index.lisp")

(form-x86-program
 (cons-x86-program
  []
  [:start
   (cons-block
    []
    [['movq [(deref-arg 'rax 10) (reg-arg 'rax)]]
     ['movq [(reg-arg 'rax) (reg-arg 'rax)]]
     (callq 'f 2)
     retq])]))
