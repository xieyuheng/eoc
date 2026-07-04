---
title: occam-lisp
date: 2025-10-28
---

在实现 GC 的时候，发现 copy GC 不太适合实现目标是方便被 C 扩展的 lisp。
但是 copy GC 适合实现没有诸如 set 和 hash 还有 record 等复杂数据类型的 lisp。
因此，适合真正极简的 lisp -- occam-lisp。

features：

- reference value 只有 cons。
- 没有 pattern matching。
- 没有 `define-data`。
