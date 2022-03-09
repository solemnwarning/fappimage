#!/bin/sh

echo "amd64 dummy program"
md5sum $0 | cut -d' ' -f1

exit
