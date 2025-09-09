#!/usr/bin/env sh

bin="./eoc trace-compile"
ext=lisp
dir=examples

find $dir -name "*.${ext}" | parallel -v ${bin} {} ">" {}.passes
