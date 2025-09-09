#!/usr/bin/env sh

bin="./eoc trace-passes"
ext=lisp
dir=examples

find $dir -name "*.test.${ext}" | parallel -v ${bin} {} ">" {}.passes
