(import-all "instr")
(import-all "x86-mod")

(export
  sysv-argument-reg-names
  sysv-caller-saved-reg-names
  sysv-callee-saved-reg-names
  sysv-argument-registers
  sysv-caller-saved-registers
  sysv-callee-saved-registers)

(define sysv-argument-reg-names     '(rdi rsi rdx rcx r8 r9))
(define sysv-caller-saved-reg-names '(rax rcx rdx rsi rdi r8 r9 r10 r11))
(define sysv-callee-saved-reg-names '(rsp rbp rbx r12 r13 r14 r15))

(define sysv-argument-registers     (list-map reg-rand sysv-argument-reg-names))
(define sysv-caller-saved-registers (list-map reg-rand sysv-caller-saved-reg-names))
(define sysv-callee-saved-registers (list-map reg-rand sysv-callee-saved-reg-names))
