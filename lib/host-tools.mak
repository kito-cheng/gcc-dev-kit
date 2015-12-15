$(GMP_SOURCE_DIR): $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_GMP))
	mkdir -p $(dir $@)
	cd $(HOSTTOOLS_SOURCE_DIR) && \
	tar -jxf $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_GMP))

$(FULL_DOWNLOAD_DIR)/$(notdir $(URL_GMP)):
	mkdir -p $(dir $@)
	curl $(URL_GMP) > $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_GMP))

$(MPFR_SOURCE_DIR): $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPFR))
	mkdir -p $(dir $@)
	cd $(HOSTTOOLS_SOURCE_DIR) && \
	tar -jxf $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPFR))

$(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPFR)):
	mkdir -p $(dir $@)
	curl $(URL_MPFR) > $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPFR))

$(MPC_SOURCE_DIR): $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPC))
	mkdir -p $(dir $@)
	cd $(HOSTTOOLS_SOURCE_DIR) && \
	tar -jxf $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPC))

$(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPC)):
	mkdir -p $(dir $@)
	curl $(URL_MPFR) > $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_MPC))

$(ISL_SOURCE_DIR): $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_ISL))
	mkdir -p $(dir $@)
	cd $(HOSTTOOLS_SOURCE_DIR) && \
	tar -jxf $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_ISL))

$(FULL_DOWNLOAD_DIR)/$(notdir $(URL_ISL)):
	mkdir -p $(dir $@)
	curl $(URL_MPFR) > $(FULL_DOWNLOAD_DIR)/$(notdir $(URL_ISL))

$(GMP_STMP): $(GMP_SOURCE_DIR)
	mkdir -p $(GMP_BUILD_DIR)
	cd $(GMP_BUILD_DIR) && \
	$(GMP_SOURCE_DIR)/configure \
	    --prefix=$(HOSTTOOLS_INSTALL_DIR) \
	    --disable-shared
	cd $(GMP_BUILD_DIR) && $(MAKE) all
	cd $(GMP_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(MPFR_STMP): $(GMP_STMP) $(MPFR_SOURCE_DIR)
	mkdir -p $(MPFR_BUILD_DIR)
	cd $(MPFR_BUILD_DIR) && \
	$(MPFR_SOURCE_DIR)/configure \
	    --prefix=$(HOSTTOOLS_INSTALL_DIR) \
	    --with-gmp=$(HOSTTOOLS_INSTALL_DIR) \
	    --disable-shared
	cd $(MPFR_BUILD_DIR) && $(MAKE) all
	cd $(MPFR_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(MPC_STMP): $(MPFR_STMP) $(GMP_STMP) $(MPC_SOURCE_DIR)
	mkdir -p $(MPC_BUILD_DIR)
	cd $(MPC_BUILD_DIR) && \
	$(MPC_SOURCE_DIR)/configure \
	    --prefix=$(HOSTTOOLS_INSTALL_DIR) \
	    --with-gmp=$(HOSTTOOLS_INSTALL_DIR) \
	    --with-mpfr=$(HOSTTOOLS_INSTALL_DIR) \
	    --disable-shared
	cd $(MPC_BUILD_DIR) && $(MAKE) all
	cd $(MPC_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(ISL_STMP): $(GMP_STMP) $(ISL_SOURCE_DIR)
	mkdir -p $(ISL_BUILD_DIR)
	cd $(ISL_BUILD_DIR) && \
	$(ISL_SOURCE_DIR)/configure \
	    --prefix=$(HOSTTOOLS_INSTALL_DIR) \
	    --with-gmp=$(HOSTTOOLS_INSTALL_DIR) \
	    --disable-shared
	cd $(ISL_BUILD_DIR) && $(MAKE) all
	cd $(ISL_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(CLOOG_STMP): $(GMP_STMP) $(ISL_STMP) $(CLOOG_SOURCE_DIR)
	mkdir -p $(CLOOG_BUILD_DIR)
	cd $(CLOOG_BUILD_DIR) && \
	$(CLOOG_SOURCE_DIR)/configure \
	    --prefix=$(HOSTTOOLS_INSTALL_DIR) \
	    --with-gmp=$(HOSTTOOLS_INSTALL_DIR) \
	    --disable-shared
	cd $(CLOOG_BUILD_DIR) && $(MAKE) all
	cd $(CLOOG_BUILD_DIR) && $(MAKE) install
	mkdir -p $(dir $@) && touch $@

$(HOST_TOOLS_STMP): $(MPC_STMP) $(MPFR_STMP) \
                    $(GMP_STMP) $(ISL_STMP)
	mkdir -p $(dir $@) && touch $@
