#!/usr/bin/env sh

bin="npx x-lisp.js run --debug=true"

find src -name "*.test.lisp" | parallel -v ${bin} {}
find src -name "*.snapshot.lisp" | parallel -v ${bin} {} ">" {}.out
find src -name "*.error.lisp" | parallel -v ${bin} {} ">" {}.err "||" true
