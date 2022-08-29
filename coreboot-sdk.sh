#!/bin/sh

while :; do
    case "$1" in
        --config)
            CONFIG="$2"
            shift 2;;
        --sdk-version)
            SDK_VERSION="$2"
            shift 2;;
        --bootorder)
            BOOTORDER="$2"
            shift 2;;
        --bootsplash)
            BOOTSPLASH="$2"
            shift 2;;
        *)
            break;;
    esac
done

uid=$(id -u)
gid=$(id -g)

docker run --rm -it \
    --user "$uid:$gid" \
    --workdir "/home/coreboot/cb_build" \
    -v "$(pwd)/coreboot:/home/coreboot/cb_build" \
    -v "$(pwd)/build:/home/coreboot/cb_build/build" \
    -v "$(pwd)/${CONFIG}:/home/coreboot/cb_build/configs/defconfig:ro" \
    -v "$(pwd)/${BOOTSPLASH}:/home/coreboot/cb_build/bootsplash.jpg:ro" \
    coreboot/coreboot-sdk:"$SDK_VERSION" \
    "$@"

#    -v "$(pwd)/${BOOTORDER}:/home/coreboot/cb_build/bootorder:ro" \
