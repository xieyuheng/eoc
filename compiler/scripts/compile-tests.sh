#!/usr/bin/env sh

bin="./eoc compile"
ext=lisp
dir=examples

for file in $(find $dir -name "*.test.${ext}"); do
    echo "[compile] $file"
    ${bin} $file > $file.s
done
