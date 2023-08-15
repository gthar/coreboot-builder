x60_seabios.rom: build/coreboot.rom
	install $< $@

include ../common.make

build/coreboot.rom: coreboot/.config coreboot
	echo "building rom"
	mkdir -p $(@D)
	$(call coreboot_sdk,\
		--volume="$(WD)/$(@D):/home/coreboot/cb_build/build" \
	) make

coreboot/.config: defconfig coreboot
	echo "building config out of defconfig"
	$(call coreboot_sdk,\
		--volume="$(WD)/$<:/home/coreboot/cb_build/configs/defconfig:ro" \
	) make defconfig
