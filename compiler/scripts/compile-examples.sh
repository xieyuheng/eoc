#!/usr/bin/env sh

bin="./eoc compile"
ext=lisp
dir=examples

find $dir -name "*.${ext}" | parallel -v ${bin} {} ">" {}.s
