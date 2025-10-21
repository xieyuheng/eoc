---
title: finding root value in register during garbage collection
date: 2025-10-21
---

# 问题

EOC 的编译器课程中，
如果可以做到在不用给 value 加 tag 的前提下实现 GC，
就有机会对 tag 的使用做优化。

比如，在一段只是处理 int 或 float 的代码中，
编译出来的汇编可以完全不用处理 tag。

因此我要寻找在没有 tag 的前提下也可以实现 GC 的方法。
没有 tag 带来的难点在于如何找到 root pointer。
对于 stack 中的 pointer，可以用 shadow pointer 来处理，
但是对于寄存器中的 pointer，目前的实现方式是，
直接在有可能做 heap allocation 的函数中避免用寄存器保存 pointer。
我现在要解决的问题就是，如果在允许寄存器保存 pointer 的同时，
分辨出来那些寄存器保存了 pointer。

# 方案

大致方案是，要能做到在编译出来的代码的任意时刻，
都能知道当前所有的寄存器所保存的 value 是 atom 还是 reference（pointer）。
在进入 GC 之前，可以先把寄存器里的 pointer 数据保存到栈中，
GC 之后再 pop 出来。

明确问题的条件：
条件显然是满足的，因为我们知道所有变量的类型，
寄存器在每一个时刻都可能被分配给某个变量，
我可以模仿 liveness 分析的过程，
找到在每一个 instr 之间的时间点，
可能保存 pointer 的寄存器的集合。

# 行动

可以借助这个机会，多研究一些 GC 相关的论文。

另外 liveness 分析所得到的信息，
是否可以表达在 basic-lisp 中？

毕竟，对 tag 的 inject 和 project
能够表达在 IR 中是我之前没有想到的，
所以也许 IR 中还可以表达很多东西。

不只是用 metadata 的形式来表达，
而是用可组合的，表达式的方式来表达，
或者说 instruction 的方式，
或者说 operation 的方式。

注意，IR 中所表达的信息，
是要为了指导代码生成而服务的。
