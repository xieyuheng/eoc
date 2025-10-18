#!/usr/bin/env sh

set -e

parallel="parallel -v --halt now,fail=1"
bin="./eoc compile-assembly"

find examples -name "*.lisp" | $parallel $bin {} ">" {}.s
