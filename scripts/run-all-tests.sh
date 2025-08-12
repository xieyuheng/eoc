#!/usr/bin/env sh

bin="racket"
ext=rkt

for file in $(find src -name "*.test.${ext}"); do
    echo "[test] $file"
    ${bin} $file
done
