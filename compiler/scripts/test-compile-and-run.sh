#!/usr/bin/env sh

set -e

parallel="parallel -v --halt now,fail=1"
bin="./eoc compile"

find examples -name "*.lisp" | $parallel $bin {} :output {}.exe
find examples -name "*.lisp.exe" | $parallel {} ">" {}.out
