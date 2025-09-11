#!/usr/bin/env sh

bin="./eoc compile"

find examples -name "*.lisp" | parallel -v ${bin} {}
find examples -name "*.lisp.exe" | parallel -v {} ">" {}.out
