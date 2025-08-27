(import-all "index.lisp")

(define (test-program expected sexp)
  (= program (parse-program sexp))
  ;; (= program (check-program program))
  ;; (= value (eval-program program))
  ;; (assert-equal expected value)
  (writeln (format-sexp sexp))
  (writeln (format-sexp (format-program program)))
  (println program))

(test-program
 1
 '(program
   ()
   ((start
     (return 1)))))

(test-program
 1
 '(program
   ()
   ((start
     (= x 1)
     (return x)))))

(test-program
 3
 '(program
   ()
   ((start
     (return (+ 1 2))))))

(test-program
 3
 '(program
   ()
   ((start
     (= x (+ 1 2))
     (return x)))))
