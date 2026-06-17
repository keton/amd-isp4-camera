# AMD ISP4 Camera Driver
KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build
MSG_ID := 20260506093250.93460-1-Bin.Du@amd.com

PATCHSET_VER := 11

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
	git clone --depth=1 -b v6.19 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git src && cd src && git am ../v$(PATCHSET_VER)_*.mbx
	cp src/drivers/media/platform/amd/isp4/*.c src/drivers/media/platform/amd/isp4/*.h .
	rm -rf src v$(PATCHSET_VER)_*.mbx v$(PATCHSET_VER)_*.cover
	sed "s/PATCHSET_VERSION/$(PATCHSET_VER)/" dkms.conf.template > dkms.conf
	touch .patched

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	depmod -a

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

distclean: clean
	rm -f $(SRCS) $(HDRS) .patched

.PHONY: all install clean distclean patch
