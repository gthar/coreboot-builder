SDK_VERSION := "2022-12-18_3b32af950d"
COMMIT := "aa1efece74"

uid := `id -u`
gid := `id -g`

clone:
    git clone https://github.com/coreboot/coreboot.git coreboot
    git -C coreboot submodule update --init --recursive --remote
    git -C coreboot checkout {{ COMMIT }}
    git -C coreboot submodule update --recursive --remote

make *ARGS:
    docker run -it \
        --userns=keep-id \
        --user {{ uid }}:{{ gid }} \
        --workdir "/home/coreboot/cb_build" \
        -v "$(pwd)/coreboot:/home/coreboot/cb_build" \
        -v "$(pwd)/build:/home/coreboot/cb_build/build" \
        coreboot/coreboot-sdk:{{ SDK_VERSION }} \
        make {{ARGS}}
