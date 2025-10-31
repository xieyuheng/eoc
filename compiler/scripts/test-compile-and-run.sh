#!/usr/bin/env sh

set -e

parallel="parallel -v --halt now,fail=1"
bin="./eoc compile"

find tests -name "*.lisp" | $parallel $bin {} :output {}.exe
find tests -name "*.lisp.exe" | $parallel {} ">" {}.out
