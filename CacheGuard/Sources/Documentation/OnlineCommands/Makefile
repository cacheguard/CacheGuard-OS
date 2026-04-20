include CacheGuard.env

SRC_FILES := $(shell ls -1 *.1)
DATE := $(shell date +"%B %Y")

GROFF_FILES = $(SRC_FILES:%.1=$(GENERATED_DIR)/%.1)
HTML_FILES =  $(SRC_FILES:%.1=$(GENERATED_DIR)/%.html)
INDEX_FILES = $(GENERATED_DIR)/index.html $(GENERATED_DIR)/help.1

all: $(GROFF_FILES) $(HTML_FILES) $(GENERATED_DIR)/help.html

$(GENERATED_DIR)/%.1: %.1 author ../../../CacheGuard.env-1 Makefile
	@echo .TH $(basename $< .1) 1 \"$(DATE)\" \"$(COMMERCIAL_NAME)-OS Version $(OS_GENERATION)-$(OS_VERSION)\" \"Administrator Manuals\" > $@
	@echo .SH NAME >> $@
	@echo -n $(basename $< .1) >> $@
	@echo -n ' - ' >> $@
	@cat $< >> $@
	@cat author >> $@
	@echo ".SH COPYRIGHT" >> $@
	@echo "Copyright (C) ${YEARS} ${COMMERCIAL_NAME} - All rights reserved" >> $@

$(GENERATED_DIR)/help.1: help.1 $(GENERATED_DIR)/help.1.commands author ../../../CacheGuard.env-1 Makefile
	@echo .TH $(basename $< .1) 1 \"$(DATE)\" \"$(COMMERCIAL_NAME)-OS Version $(OS_GENERATION)-$(OS_VERSION)\" \"Administrator Manuals\" > $@
	@echo .SH NAME >> $@
	@echo -n $(basename $< .1) >> $@
	@echo -n ' \- ' >> $@
	@cat $< >> $@
	@cat $@.commands >> $@
	@cat author >> $@
	@echo ".SH COPYRIGHT" >> $@
	@echo "Copyright (C) ${YEARS} ${COMMERCIAL_NAME} - All rights reserved" >> $@

$(GENERATED_DIR)/%.html: $(GENERATED_DIR)/%.1 Makefile
	@groff -man -Thtml -mwww $< | tail -n+3 > /tmp/man.html.tmp
	@sed \
		-e '/<!DOCTYPE/,+2d' \
		-e '/<head>/i <!DOCTYPE html>' \
		-e '/<head>/i <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">' \
		-e '/<head>/a <link rel="shortcut icon" type="image/x-image" href="/${DOC_DIR_NAME}/favicon.ico" />' \
		-e '/<head>/a <link rel="stylesheet" type="text/css" href="/${DOC_DIR_NAME}/apl.css" />' \
		-e 's@<body>@<body><a href=index.html><img src="/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/CacheGuardLogo.png" align=left alt="" border="0" height="65" /></a><br><br>@' \
		/tmp/man.html.tmp > $@
	@rm -f /tmp/man.html.tmp

clean:
	@rm -f *~ $(GROFF_FILES) $(HTML_FILES) $(INDEX_FILES)
