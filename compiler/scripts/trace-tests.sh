#!/usr/bin/env sh

bin="./eoc trace-compile"
ext=lisp
dir=examples

find $dir -name "*.test.${ext}" | parallel -v ${bin} {} ">" {}.passes
