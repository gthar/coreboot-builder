#!/bin/sh

while :; do
    case "$1" in
    --config)
        CONFIG="$2"
        shift 2
        ;;
    --sdk-version)
        SDK_VERSION="$2"
        shift 2
        ;;
    --bootsplash)
        BOOTSPLASH="$2"
        shift 2
        ;;
    --vgabios)
        VGABIOS="$2"
        shift 2
        ;;
    *)
        break
        ;;
    esac
done

[ -e "${VGABIOS}" ] &&
    VGABIOS_MNT="-v $(pwd)/${VGABIOS}:/home/coreboot/cb_build/vgabios.bin:ro"

uid=$(id -u)
gid=$(id -g)

podman run --rm -it \
    --userns=keep-id \
    --user "$uid:$gid" \
    --workdir "/home/coreboot/cb_build" \
    -v "$(pwd)/coreboot:/home/coreboot/cb_build" \
    -v "$(pwd)/build:/home/coreboot/cb_build/build" \
    -v "$(pwd)/${CONFIG}:/home/coreboot/cb_build/configs/defconfig:ro" \
    -v "$(pwd)/${BOOTSPLASH}:/home/coreboot/cb_build/bootsplash.jpg:ro" \
    $VGABIOS_MNT \
    coreboot/coreboot-sdk:"$SDK_VERSION" \
    "$@"
