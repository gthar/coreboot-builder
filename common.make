# note: to produce `defconfig`, you can do the following:
# 	1. run `make menuconfig` to create a .config
# 	2. run `make savedefconfig` to strip out the default values from .config
# 	   and be left with defconfig

SDK_VERSION=2022-12-18_3b32af950d
COREBOOT_COMMIT=aa1efece74

REPO_URL=https://github.com/coreboot/coreboot.git

UID:=$(shell id -u)
GID:=$(shell id -g)

WD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define coreboot_sdk
	podman run --rm -it \
		--userns=keep-id \
		--user=$(UID):$(GID) \
		--workdir="/home/coreboot/cb_build" \
		--volume="$(WD)/coreboot:/home/coreboot/cb_build" \
		$(1) \
		coreboot/coreboot-sdk:$(SDK_VERSION)
endef

coreboot:
	echo "cloning coreboot code"
	git clone $(REPO_URL) $@
	git -C $@ submodule update --init --recursive --remote
	git -C $@ checkout $(COREBOOT_COMMIT)
	git -C $@ submodule update --recursive --remote

# vi: ft=make
