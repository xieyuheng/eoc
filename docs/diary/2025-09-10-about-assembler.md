---
title: about assembler
date: 2025-09-10
---

如果想要完全独立，就需要有自己的汇编器。
但是由于我们需要用 C 写 runtime，
所以整体看来长期都会依赖 gcc。
因此先不写自己的汇编器，先依赖 gas。

汇编器所解决的问题是：

- 把 instruction 翻译成 machine code。
- 同时把 label 翻译成 machine code 中的相对位置。

但是汇编器的本质是 byte layer （类似 brick layer）。
比如看 uxn 的汇编器，在其中用 byte 就直接生成 byte，
类似默认就是 db 或者 dw。

汇编器主要与 encode 和 decode 有关。
也是很有代表性的程序，是解决很多问题的思路。

在之后的阅读中（比如学习 8086 的时候），
我们可以尝试设计 lisp 语法的 assembler（比如叫做 xasm）。
就像我们学习其他计算模型时，设计自己 lisp 语法一样。

这里所设计的 lisp 汇编语法将会成为未来我们自己的汇编器的语法。
未来的汇编器本身应该能够把 x-lisp 当作扩展语言，
来从写汇编器中的 macro（lisp 级别的 macro）。
