#!/usr/bin/env sh

bin="./eoc trace-passes"
ext=lisp
dir=examples

for file in $(find $dir -name "*.test.${ext}"); do
    echo "[snapshot] $file"
    ${bin} $file > $file.passes
done
