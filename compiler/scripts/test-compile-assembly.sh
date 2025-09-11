#!/usr/bin/env sh

bin="./eoc compile"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.s
