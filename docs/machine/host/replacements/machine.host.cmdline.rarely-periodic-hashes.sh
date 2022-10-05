#!/bin/bash
cartesi-machine \
    --append-rom-bootargs="single=yes" \
    --flash-drive="label:input,length:1<<12" \
    --flash-drive="label:output,length:1<<12" \
    --max-mcycle=0 \
    --final-hash \
    --store="calculator-template" \
    -- $'dd status=none if=$(flashdrive input) | lua -e \'print((string.unpack("z", io.read("a"))))\' | bc | dd status=none of=$(flashdrive output)' \
    > /dev/null 2>&1

echo "6*2^1024 + 3*2^512" > input.raw
truncate -s 4K input.raw

cartesi-machine \
    --load="calculator-template" \
    --replace-flash-drive="start:0x9000000000000000,length:1<<12,filename:input.raw" \
    --periodic-hashes=1,$1 \
    2>&1

rm -r calculator-template
rm input.raw
