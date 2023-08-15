x230_seabios.rom: build/coreboot_top_prepared_12mb.rom
	install $< $@

include ../common.make

build/coreboot_top_prepared_12mb.rom: build/coreboot_top.rom
	dd if=/dev/zero of="$@" bs=4M count=2 status=none
	dd if="$<" oflag=append conv=notrunc of="$@" bs=4M status=none

build/coreboot_top.rom: build/coreboot.rom
	dd if="$<" of="$@" bs=1M skip=8

build/coreboot.rom: coreboot/.config bootorder bootsplash.jpg vgabios.bin coreboot
	echo "building rom"
	mkdir -p $(@D)
	$(call coreboot_sdk,\
		--volume="$(WD)/$(@D):/home/coreboot/cb_build/build" \
		--volume="$(WD)/bootorder:/home/coreboot/cb_build/bootorder:ro" \
		--volume="$(WD)/bootsplash.jpg:/home/coreboot/cb_build/bootsplash.jpg:ro" \
		--volume="$(WD)/vgabios.bin:/home/coreboot/cb_build/vgabios.bin:ro" \
	) make

coreboot/.config: defconfig coreboot
	echo "building config out of defconfig"
	$(call coreboot_sdk,\
		--volume="$(WD)/$<:/home/coreboot/cb_build/configs/defconfig:ro" \
	) make defconfig
