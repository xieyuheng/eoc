#!/usr/bin/env sh

bin="occam-lisp.js debug"
ext=lisp

for file in $(find src -name "*.${ext}"); do
    echo "[test] $file"
    ${bin} $file
done
