#!/usr/bin/env sh

bin="./eoc compile-assembly"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.s

bin="./eoc compile-assembly :optimization-level 1"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.O1.s
