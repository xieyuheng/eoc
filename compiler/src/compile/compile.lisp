(import-all "deps.lisp")

(export
  compile-program)

(claim compile-program
  (-> program? x86-program?))

(define (compile-program program)
  (= program-0 (check-program program))
  (= program-1 (check-program (uniquify program-0)))
  (= program-2 (check-program (rco-program program-1)))
  (= c-program-3 (check-c-program (explicate-control program-2)))
  (= x86-program-4 (select-instructions c-program-3))
  (= x86-program-5 (assign-homes x86-program-4))
  (= x86-program-6 (patch-instructions x86-program-5))
  (= x86-program-7 (prolog-and-epilog x86-program-6))
  x86-program-7)
