#!/bin/bash

set -e

I386_DUMMY_OUTPUT=$(cat <<'EOF'
i386 dummy program
4480a49d702a9e9aa91b5763c78687c5
EOF
)

AMD64_DUMMY_OUTPUT=$(cat <<'EOF'
amd64 dummy program
643c59fb1873cac8be22d7a018c46e75
EOF
)

ARM_DUMMY_OUYPUT=$(cat <<'EOF'
arm dummy program
e801ad7514e54af6b0be5a477afade3c
EOF
)

AARCH64_DUMMY_OUTPUT=$(cat <<'EOF'
aarch64 dummy program
0d5cd1edd420f03c215741caafcdf14e
EOF
)

result=0

./fappimage \
	--i386 tests/i386-dummy.sh \
	--amd64 tests/amd64-dummy.sh \
	--arm tests/arm-dummy.sh \
	--aarch64 tests/aarch64-dummy.sh \
	--output tests/output.sh

function dotest()
{
	local output="$(./tests/output.sh 2>&1)"
	
	if [ "$output" != "$1" ]
	then
		echo "Incorrect output for machine '$MOCK_UNAME_MACHINE':" 1>&2
		echo "$output" 1>&2
		
		result=$((result + 1))
	fi
}

PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="i386" dotest "$I386_DUMMY_OUTPUT"
PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="i686" dotest "$I386_DUMMY_OUTPUT"

PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="x86_64" dotest "$AMD64_DUMMY_OUTPUT"

PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="arm"    dotest "$ARM_DUMMY_OUYPUT"
PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="armv7l" dotest "$ARM_DUMMY_OUYPUT"

PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="aarch64"    dotest "$AARCH64_DUMMY_OUTPUT"
PATH="$(pwd)/tests/mock-uname:$PATH" MOCK_UNAME_MACHINE="aarch64_be" dotest "$AARCH64_DUMMY_OUTPUT"

if [ "$result" -eq "0" ]
then
	echo "All tests passed"
else
	echo "Failed $result tests"
fi

exit $result
