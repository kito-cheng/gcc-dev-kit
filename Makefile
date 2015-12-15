CONFIG:=config.mak
PWD:=$(shell pwd)
KCONFIG_DIR:=$(PWD)/kconfig
MCONF:=mconf

-include $(CONFIG)
# Include path.mak for initialize XXX_DIR
include lib/path.mak
# Include stmp.mak for initialize XXX_STMP
include lib/stmp.mak
# Include var.mak for initialize misc variables
include lib/var.mak
include lib/src-url.mak

all: $(GCC_BOOTSTRAP_STMP) $(BINUTILS_STMP)

$(KCONFIG_DIR):
	git clone git@github.com:nds32/kconfig.git

$(KCONFIG_DIR)/$(MCONF): $(KCONFIG_DIR)
	cd $(KCONFIG_DIR) && \
	  make -f Makefile.olibc mconf obj=`pwd` \
	  CC="gcc" HOSTCC="gcc" LKC_GENPARSER=1

config: $(KCONFIG_DIR)/$(MCONF)
	TOOLCHAIN_CONFIG=$(CONFIG) $(KCONFIG_DIR)/$(MCONF) lib/Config.in

$(CONFIG): $(KCONFIG_DIR)/$(MCONF)
	TOOLCHAIN_CONFIG=$(CONFIG) $(KCONFIG_DIR)/$(MCONF) lib/Config.in

$(TOOLCHAIN_STMP): $(BINUTILS_STMP)

test:

sync:

include lib/host-tool.mak
include lib/host-tools.mak
include lib/toolchain.mak
