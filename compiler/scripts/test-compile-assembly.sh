#!/usr/bin/env sh

bin="./eoc compile-assembly"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.s
