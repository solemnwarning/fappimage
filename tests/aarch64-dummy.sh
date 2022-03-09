#!/bin/sh

echo "aarch64 dummy program"
md5sum $0 | cut -d' ' -f1

exit
