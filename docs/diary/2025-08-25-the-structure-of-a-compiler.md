---
title: the structure of a compiler
date: 2025-08-25
---

为了让人们容易理解 compiler，而使用下面的构架：

一组相互独立的语言：

```
langs/
- s
- c
- x86
```

一系列语言之间的 passes：

```
passes/
- 010-uniquify
- 020-remove-complex-operands
- 030-explicate-control
- 040-select-instructions
- 050-allocate-registers
- 060-patch-instructions
- 070-prolog-and-epilog
```

每个语言都有一个顶层的 program 数据类型。
使得一个 pass 可以理解为是 program 到 program 的函数。
program 之外的参数可以被理解为被 curry 的 parameter
-- `(-> parameter program program)`。
