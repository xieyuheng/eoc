#!/usr/bin/env sh

bin="./eoc compile-passes"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.passes
