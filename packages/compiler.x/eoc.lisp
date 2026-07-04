(import-all "src/index.lisp")

(match (list-drop 2 (current-command-line-args))
  (['compile input :output output]
   (= input-file (symbol-to-string input))
   (= mod (load-mod input-file))
   (= x86-mod (compile-mod mod))
   (= output-file (if (null? output)
                    (string-append input-file ".exe")
                    (symbol-to-string output)))
   (generate-exe x86-mod output-file))

  (['compile-assembly input]
   (= input-file (symbol-to-string input))
   (= mod (load-mod input-file))
   (= x86-mod (compile-mod mod))
   (write (format-x86-mod x86-mod)))

  (['compile-passes input]
   (= input-file (symbol-to-string input))
   (= mod (load-mod input-file))
   (compile-passes mod))

  (['help]
   (print-help))

  (_
   (print-help)))

(define runtime-file
  (path-join [(current-module-directory) "../runtime/runtime.o"]))

(define tmp-directory "/tmp/eoc")

(define (generate-exe x86-mod output-file)
  (= output-id (string-replace "/" "-" output-file))
  (= asm-id (string-concat
             [output-id "." (format-sexp (random-int 0 10000)) ".s"]))
  (= asm-file (path-join [tmp-directory asm-id]))
  (directory-create-recursively (file-directory asm-file))
  (file-save asm-file (format-x86-mod x86-mod))
  (= [:exit-code exit-code :stdout stdout :stderr stderr]
     (system-shell-run "cc" [asm-file runtime-file "-o" output-file]))
  (if (equal? exit-code 0)
    (file-delete asm-file)
    (begin
      (write stderr)
      (exit [:who 'generate-exe
             :message "c compiler fail"
             :output-file output-file]))))

(define (load-mod file)
  (parse-mod
   `(mod
     ()
     ,(parse-sexp (file-load file)))))

(define (print-help)
  (write "commands:")
  (write "\n  compile-assembly <file> -- compile a file to assembly")
  (write "\n  compile-passes <file> -- output all compiler passes for snapshot testing")
  (write "\n  help -- display help information")
  (write "\n")
  (write "\ndefault command: help"))
