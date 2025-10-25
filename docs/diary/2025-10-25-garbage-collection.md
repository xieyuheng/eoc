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

- 需要暴露底层的 allocation 结构，
  set 和 hash 一类的数据类型，
  都要在 lisp 内实现。

方案 B：使用 C 函数处理 allocation。

- 缺点是每次 allocation 都会有函数调用。

- 方便用 C 扩展，用 C 实现 builtin data types，比如 set 和 hash。

我想，在 EOC 这个练习性质的项目中，
我可以跟着老师实现方案 A。

但是在 x-lisp 中，很有可能应该实现方案 B，
因为 x-lisp 有稳定的 collection 数据类型，
在 x-lisp 中实现这些数据类型需要暴露底层接口，
而我不想暴露底层接口。

另外，关于这些 collection 数据类型的 API，
可能用 C 写所带来的效率提升，
可以超过 fast allocation 的效率。

x-lisp 也需要更方便地用 C 扩展，
而不是追求尽量多的代码用 x-lisp 写。

并且在 x-lisp 中，可能所有的 value 都需要带有 tag。
