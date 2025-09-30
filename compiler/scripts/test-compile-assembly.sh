#!/usr/bin/env sh

set -e
parallel="parallel -v --halt now,fail=1"
bin="./eoc compile-assembly"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.s
bin="./eoc compile-assembly :optimization-level 1"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.O1.s
bin="./eoc compile-assembly :optimization-level 2"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.O2.s
