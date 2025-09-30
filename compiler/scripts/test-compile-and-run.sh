#!/usr/bin/env sh

set -e
parallel="parallel -v --halt now,fail=1"
bin="./eoc compile"
find examples -name "*.lisp" | $parallel $bin {} :output {}.exe
find examples -name "*.lisp.exe" | $parallel {} ">" {}.out
bin="./eoc compile :optimization-level 1"
find examples -name "*.lisp" | $parallel $bin {} :output {}.O1.exe
find examples -name "*.lisp.O1.exe" | $parallel {} ">" {}.out
bin="./eoc compile :optimization-level 2"
find examples -name "*.lisp" | $parallel $bin {} :output {}.O2.exe
find examples -name "*.lisp.O2.exe" | $parallel {} ">" {}.out
