#!/usr/bin/env sh

bin="./eoc trace-compile"

find examples -name "*.lisp" | parallel -v ${bin} {} ">" {}.passes
