# AMD ISP4 Camera Driver
KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build
MSG_ID := 20251216091326.111977-1-Bin.Du@amd.com

SRCS := isp4.c isp4_debug.c isp4_interface.c isp4_subdev.c isp4_video.c
HDRS := isp4.h isp4_debug.h isp4_interface.h isp4_subdev.h isp4_video.h isp4_fw_cmd_resp.h isp4_hw_reg.h

obj-m += amd_capture.o
amd_capture-objs := isp4.o isp4_debug.o isp4_interface.o isp4_subdev.o isp4_video.o

all: $(SRCS) $(HDRS)
	$(MAKE) -C $(KDIR) M=$(PWD) modules

$(SRCS) $(HDRS): patch
	@touch $@

patch: .patched

.patched:
	b4 am -l $(MSG_ID)
	git clone --depth=1 -b v6.18 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git src && cd src && git am ../v7_*.mbx
	cp src/drivers/media/platform/amd/isp4/*.c src/drivers/media/platform/amd/isp4/*.h .
	rm -rf src v7_*.mbx v7_*.cover
	touch .patched

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	depmod -a
	echo "amd_capture" > /etc/modules-load.d/amd-camera.conf
	modprobe amd_capture

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

distclean: clean
	rm -f $(SRCS) $(HDRS) .patched

.PHONY: all install clean distclean patch
