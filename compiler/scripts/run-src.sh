#!/usr/bin/env sh

bin="npx x-lisp.js run --debug=true"
ext=lisp
dir=src

find $dir -name "*.test.${ext}" | parallel -v ${bin} {}
find $dir -name "*.snapshot.${ext}" | parallel -v ${bin} {} ">" {}.out
find $dir -name "*.error.${ext}" | parallel -v ${bin} {} ">" {}.err "||" true
