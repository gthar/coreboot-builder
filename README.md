# coreboot-builder

This is what I use to build my coreboot images. It is heavily based on the
scripts and configurations used by [skulls](https://github.com/merge/skulls).
But simplified to support only my very specific hardware and preferences. This
makes it leaner to use and easier for me to understand it, so it's easier to
customize (for example, if I want to change the boot order).

Currently I have only one config for my Thinkpad X230; `capibara`, and I use a
the "free" config (with the VGA BIOS SeaVGABIOS instead of the Intel one).

## Build process

I use a Makefile to orchestrate cloning the coreboot code, checking out the
right commit, compiling the image, flashing it, etc.
The coreboot SDK is run from a docker image because I couldn't manage to
compile everything otherwise.

## Splash screen

For an X230 the splash screen image needs to be a JPEG using:

* with "progressive" turned off
* "4:2:0 (chroma quartered)" Subsampling
* 1024px wide and 768px tall

But the X230 screen happens to be 16:9 (1366px wide, 768px tall). When the
SaBIOSVABIOS is used, the image is just shown centered in the screen, with
black blocks on each side. When the Intel VGA is used, the image is stretched
to fill the whole 1366 x 768 screen. So make sure to plan accordingly to make
the image look right.

Also, the SeaBIOS VGA seems to show weird colors when booting. I don't know
how to fix that, so I just keep the image pure black and white to make it look
decent.

## Updates

I try to follow skull's releases and update the coreboot commit, sdk version
and config as they do it.

Last release happened on 2022/05/03.

## Flashing

Before flashing, the system needs to boot with the kernel parameter
`iomem=relaxed`.

* Reboot the computer
* When the GRUB screen appears, press `e` to edit the startup command
* Append `iomem=relaxed` to the kernel command
* Press `ctrl-x` or `F2` to boot the system with the modification
* Then flash the new image with:

```sh
flash: build/coreboot_top_prepared_12mb.rom layout.txt
	flashrom \
		--force \
		--noverify-all\
		-p internal \
		--layout layout.txt \
		--image bios \
		-w build/coreboot_top_prepared_12mb.rom
```
