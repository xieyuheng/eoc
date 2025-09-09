#!/usr/bin/env sh

bin="./eoc compile"
ext=lisp
dir=examples

find $dir -name "*.test.${ext}" | parallel -v ${bin} {} :output {}.s
