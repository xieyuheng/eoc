(import-all "x86-program")

(export
  sysv-caller-saved-reg-names
  sysv-callee-saved-reg-names
  sysv-caller-saved-registers
  sysv-callee-saved-registers)

(define sysv-caller-saved-reg-names '(rax rcx rdx rsi rdi r8 r9 r10 r11))
(define sysv-callee-saved-reg-names '(rsp rbp rbx r12 r13 r14 r15))

(define sysv-caller-saved-registers (list-map reg-rand sysv-caller-saved-reg-names))
(define sysv-callee-saved-registers (list-map reg-rand sysv-callee-saved-reg-names))
