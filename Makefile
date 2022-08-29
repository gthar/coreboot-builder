CONFIG=free-defconfig-d5c31acee4
SDK_VERSION=2022-04-04_9a8d0a03db
BOOTSPLASH=bootsplash.jpg
# BOOTORDER=bootorder
REPO_URL=https://github.com/coreboot/coreboot.git
COMMIT=d5c31acee4

COREBOOT_CONFIG=coreboot/.config
BUILDER=./coreboot-sdk.sh \
		--config $(CONFIG) \
		--sdk-version $(SDK_VERSION) \
		--bootsplash $(BOOTSPLASH)
#--bootorder $(BOOTORDER)

.PHONY: clean nuke defconfig checkout flash

build/coreboot_top_prepared_12mb.rom: build/coreboot_top.rom
	dd if=/dev/zero of="$@" bs=4M count=2 status=none
	dd if="$<" oflag=append conv=notrunc of="$@" bs=4M status=none

build/coreboot_top.rom.sha256: build/coreboot_top.rom
	sha256sum "$<" > "$@"

build/coreboot_top.rom: build/coreboot.rom
	dd if="$<" of="$@" bs=1M skip=8

build/coreboot.rom: $(COREBOOT_CONFIG) $(BOOTSPLASH) $(bootorder)
	mkdir -p build
	$(BUILDER) make

$(COREBOOT_CONFIG): $(CONFIG) checkout
	mkdir -p build
	$(BUILDER) make defconfig

defconfig: $(COREBOOT_CONFIG)

coreboot:  # clone
	git clone $(REPO_URL) $@
	git -C coreboot submodule update --init --recursive --remote

checkout: coreboot
	git -C coreboot checkout $(COMMIT)
	git -C coreboot submodule update --recursive --remote

clean:
	rm -rf coreboot/.config
	rm -rf build

nuke: clean
	rm -rf coreboot

flash: build/coreboot_top_prepared_12mb.rom layout.txt
	flashrom \
		--force \
		--noverify-all\
		-p internal \
		--layout layout.txt \
		--image bios \
		-w build/coreboot_top_prepared_12mb.rom
