#!/usr/bin/env sh

sh scripts/test-src.sh &&
sh scripts/test-compile-passes.sh &&
sh scripts/test-compile-assembly.sh &&
sh scripts/test-compile-and-run.sh
