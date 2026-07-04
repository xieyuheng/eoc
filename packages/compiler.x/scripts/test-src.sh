#!/usr/bin/env sh

set -e

parallel="parallel -v --halt now,fail=1"
bin="./node_modules/.bin/x-lisp-proto.js run"
flags="--debug"

find src -name "*.test.lisp" | $parallel $bin {} $flags
find src -name "*.snapshot.lisp" | $parallel $bin {} $flags ">" {}.out
find src -name "*.error.lisp" | $parallel $bin {} $flags ">" {}.err "||" true
