#!/usr/bin/env sh

bin="./eoc compile"

find examples -name "*.lisp" | parallel -v ${bin} {} :output {}.exe
find examples -name "*.lisp.exe" | parallel -v {} ">" {}.out

bin="./eoc compile :optimization-level 1"

find examples -name "*.lisp" | parallel -v ${bin} {} :output {}.O1.exe
find examples -name "*.lisp.O1.exe" | parallel -v {} ">" {}.out
