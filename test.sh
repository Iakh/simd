#!/bin/zsh

dub clean &&
dub test --compiler=dmd && dub clean &&
dub test --compiler=gdc && dub clean &&
dub test --compiler=ldc && dub clean &&
echo "=== All compilers done well ==="
