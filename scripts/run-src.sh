#!/usr/bin/env sh

bin="npx occam-lisp.js run --debug=true"
ext=lisp
dir=src

for file in $(find $dir -name "*.${ext}" -not -name "*.snapshot.${ext}" -not -name "*.error.${ext}" -not -name "*.play.${ext}" -not -name "*.benchmark.${ext}"); do
    echo "[run] $file"
    ${bin} $file
done

for file in $(find $dir -name "*.snapshot.${ext}"); do
    echo "[out] $file"
    ${bin} $file > $file.out
done

for file in $(find $dir -name "*.error.${ext}"); do
    echo "[err] $file"
    ${bin} $file > $file.err || true
done
