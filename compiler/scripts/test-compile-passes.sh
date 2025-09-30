#!/usr/bin/env sh

parallel="parallel -v --halt now,fail=1"
bin="./eoc compile-passes"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.passes
bin="./eoc compile-passes :optimization-level 1"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.O1.passes
bin="./eoc compile-passes :optimization-level 2"
find examples -name "*.lisp" | $parallel $bin {} ">" {}.O2.passes
