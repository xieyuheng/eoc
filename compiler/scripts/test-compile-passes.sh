#!/usr/bin/env sh

parallel="parallel -v --halt now,fail=1"
bin="./eoc compile-passes"

find examples -name "*.lisp" | $parallel $bin {} ">" {}.passes
