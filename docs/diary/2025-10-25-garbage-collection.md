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
