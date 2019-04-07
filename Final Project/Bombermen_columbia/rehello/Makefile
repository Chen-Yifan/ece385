ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_led.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /usr/src/linux
        PWD := $(shell pwd)
CFLAGS = -Wall

default: module hello 

hello: hello.o usbkeyboard.o
	cc $(CFLAGS) -o hello hello.o usbkeyboard.o -lusb-1.0 -pthread 

hello.o: hello.c usbkeyboard.h sprite.h
usbkeyboard.o: usbkeyboard.c usbkeyboard.h

module:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} hello

socfpga.dtb : socfpga.dtb
	dtc -O dtb -o socfpga.dtb socfpga.dts

endif 
