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
