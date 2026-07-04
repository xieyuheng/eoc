---
title: wrong structure of language
date: 2025-10-17
---

这个教程还有一个错误的地方，
那就是没有在一开始就引入函数的概念，
导致开始的时候语言的结构是：

- program
  - basic block
    - instruction

正确的结构应该是：

- program
  - function
    - basic block
      - instruction

这意义是什么？
让学生一开始不用考虑有函数存在？
但是一开始就不得不讲 calling convention，
所编译出来的函数也是需要 runtime 的函数调用的，
所以根本就没法避开函数的概念。

学生看到一个没有函数的语言，
反而会感到疑惑，一直想着之后如何处理函数。
然后果然在引入函数的时候，要 refactor 大量代码。
