---
title: garbage collection
date: 2025-10-25
---

6.12 Further Reading 说：

> The strengths of copying collectors are that allocation is fast
> (just a comparison and pointer increment), ...

想要做到这一点，就只能用编译出来的汇编代码处理 allocation。

方案 A：使用汇编处理 allocation。

- 可以做到上面提到的 fast allocation。

- GC 与编译器的联系更紧密，
  GC 要暴露全局变量给编译器，
  编译器要在 frontend 的早期，
  就用一个 pass 处理 allocation。

- 需要暴露底层的 allocation API，
  set 和 hash 一类的数据类型，
  都要在 lisp 内实现。

方案 B：使用 C 函数处理 allocation。

- 缺点是每次 allocation 都会有函数调用。

- 编译器与 GC 几乎完全解耦。

- 方便用 C 扩展，用 C 实现 builtin data types，比如 set 和 hash。

我认为方案 B 更好。

因为在一般的 allocation 过程中，
除了像 malloc 一样给出内存，
还需要初始化内存，
这一般还是需要一个函数调用。

在 x-lisp 中，更应该实现方案 B，
因为 x-lisp 有稳定的 collection 数据类型，
这些数据类型很容易用 C 实现。
如果在 x-lisp 中实现这些数据类型，
就需要暴露底层接口，而我不想暴露底层接口。

另外，关于这些 collection 数据类型的 API，
可能用 C 写所带来的效率提升，
可以超过 fast allocation 的效率。

x-lisp 也需要更方便地用 C 扩展，
而不是追求尽量多的代码用 x-lisp 写。

并且在 x-lisp 中，可能所有的 value 都需要带有 tag。

# 更正

[2025-10-28]

即便假设所有的 value 都带有 tag，
在 GC 之前还是要将所有可能保存 pointer 的 register 保存到 root stack 中，
但是这部分代码没法用 C 实现！

因此，对 tuple 的 allocation 和 GC 还是要分开，
并且需要暴露 GC 的接口，然后用编译器通过生成 `if`，
来实现是否需要 GC 的判断，
并且在需要 GC 的时候准备好 root stack。

在判断需要 GC 之后，
可以将所有可能保存 value 的寄存器都保存到 root stack 中，
交给 GC 去处理。

这样做有什么后果？
这是否相当于我们必须实现方案 A？

假设要保持 set 和 hash 一类的数据类型在 C 中实现。

如果想要用 C 实现这些数据类型，
就必须让 C 所扩展的数据类型与 GC 兼容。
假设用简单的 mark-sweep GC，
那么每个 C object 都要有自己的 mark 规则。

每次 allocation object 时，
需要把 object 记录到一个 object-stack 中。
sweep 的时候扫描这个 object-stack 来做回收。

此时 GC 的信号不再是一个「from-space 已满」这样一个硬性地要求，
而是「object-stack 比较大了」这样一个 heuristic。

这可以由编译器后端的代码生成来处理，
每当遇到一个 create object 的 primitive，
都编译一个 if 来判断是否「object-stack 比较大了」，
如果是，就进行 GC，
而 GC 之前要保存所有寄存器到中的值到 root-stack 中。

好像也可以直接在 GC 代码中使用 inline assembly，
做到把所有 register 都保存到 root-stack 中，
这样就不需要编译器有任何特殊处理了。

也就是说，编译器生成代码的时候，不用做 if 判断。
