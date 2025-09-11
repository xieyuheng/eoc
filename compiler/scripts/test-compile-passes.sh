#!/usr/bin/env sh

bin="./eoc compile-passes"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.passes

bin="./eoc compile-passes :optimization-level 1"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.O1.passes
