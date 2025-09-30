#!/usr/bin/env sh

set -e

parallel="parallel -v --halt now,fail=1"
bin="./node_modules/.bin/x-lisp.js run --debug=true"

find src -name "*.test.lisp" | $parallel $bin {}
find src -name "*.snapshot.lisp" | $parallel $bin {} ">" {}.out
find src -name "*.error.lisp" | $parallel $bin {} ">" {}.err "||" true
