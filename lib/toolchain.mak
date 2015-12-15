BUILD_GCC_BOOTSTRAP_DIR:=$(BUILD_DIR)/build-bootstrap-gcc
TARGET_TRIPLE:=nds32le-elf

$(BINUTILS_CONFIGURE_STMP): $(CONFIG)
	mkdir -p $(BINUTILS_BUILD_DIR)
	cd $(BINUTILS_BUILD_DIR) && \
	$(BINUTILS_SOURCE_DIR)/configure \
	    --prefix=$(TOOLCHAIN_INSTALL_DIR) \
	    --target=$(TARGET_TRIPLE) \
	    --with-arch=$(TARGET_ARCH) \
	    --disable-nls \
	    --disable-werror
	mkdir -p $(dir $@) && touch $@

$(BINUTILS_STMP): $(BINUTILS_CONFIGURE_STMP) \
                  $(shell find $(BINUTILS_SOURCE_DIR)/ -type f -name *nds32*)
	cd $(BINUTILS_BUILD_DIR) && $(MAKE) all
	cd $(BINUTILS_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(GCC_BOOTSTRAP_CONFIGURE_STMP): $(HOST_TOOLS_STMP) $(CONFIG)
	mkdir -p $(GCC_BOOTSTRAP_BUILD_DIR)
	cd $(GCC_BOOTSTRAP_BUILD_DIR) && \
	$(GCC_SOURCE_DIR)/configure \
	    --prefix=$(TOOLCHAIN_INSTALL_DIR) \
	    --target=$(TARGET_TRIPLE) \
	    --with-arch=$(TARGET_ARCH) \
	    --disable-nls \
	    --enable-languages=c \
	    --enable-threads=single \
	    --with-newlib \
	    --with-gmp=$(HOSTTOOLS_DIR) \
	    --with-mpfr=$(HOSTTOOLS_DIR) \
	    --with-mpc=$(HOSTTOOLS_DIR) \
	    --with-isl=$(HOSTTOOLS_DIR) \
	    --with-cloog=$(HOSTTOOLS_DIR)
	mkdir -p $(dir $@) && touch $@

$(GCC_BOOTSTRAP_STMP): $(GCC_BOOTSTRAP_CONFIGURE_STMP)
	mkdir -p $(GCC_BOOTSTRAP_BUILD_DIR)
	cd $(GCC_BOOTSTRAP_BUILD_DIR) && $(MAKE) all-gcc
	cd $(GCC_BOOTSTRAP_BUILD_DIR) && $(MAKE) install-gcc
	mkdir -p $(dir $@) && touch $@

$(TOOLCHAIN_STMP): \
    $(GCC_FINAL_STMP) \
    $(BINUTILS_STMP) \
    $(NEWLIB_STMP) \
    $(GDB_STMP)

