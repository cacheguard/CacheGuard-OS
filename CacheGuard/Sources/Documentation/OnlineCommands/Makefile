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
	@echo -n ' \- ' >> $@
	@cat $< >> $@
	@cat author >> $@
	@echo ".SH COPYRIGHT" >> $@
	@echo "Copyright (C) $(YEARS) $(COMPANY_NAME) - All rights reserved" >> $@

$(GENERATED_DIR)/help.1: help.1 $(GENERATED_DIR)/help.1.commands author ../../../CacheGuard.env-1 Makefile
	@echo .TH $(basename $< .1) 1 \"$(DATE)\" \"$(COMMERCIAL_NAME)-OS Version $(OS_GENERATION)-$(OS_VERSION)\" \"Administrator Manuals\" > $@
	@echo .SH NAME >> $@
	@echo -n $(basename $< .1) >> $@
	@echo -n ' \- ' >> $@
	@cat $< >> $@
	@cat $@.commands >> $@
	@cat author >> $@
	@echo ".SH COPYRIGHT" >> $@
	@echo "Copyright (C) $(YEARS) $(COMPANY_NAME) - All rights reserved" >> $@

$(GENERATED_DIR)/%.html: $(GENERATED_DIR)/%.1 Makefile
	@groff -man -Thtml -mwww $< | tail -n+3 > /tmp/man.html.tmp
	@sed -E \
		-e '/<!DOCTYPE/,+2d' \
		-e '/<head>/i <!DOCTYPE html>' \
		-e '/<head>/i <html lang="en">' \
		-e '/<head>/a <link rel="shortcut icon" type="image/x-image" href="/favicon.ico" />' \
		-e '/<head>/a <link rel="stylesheet" type="text/css" href="/$(DOC_DIR_NAME)/apl-$(GUI_FE_VERSION).css" />' \
		-e 's@<body>@<body><a href=\"/${DOC_DIR_NAME}/${DOC_COMMAND_DIR_NAME}/index.html\"><img src="/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/CacheGuardLogo.png" align=left alt="" border="0" height="65" /></a><br><br>@' \
		-e '/<meta http-equiv=/d' \
		-e '/<style type="text\/css">/,/<\/style>/d' \
		-e 's@<title>(.*)</title>@<title>$(COMMERCIAL_NAME) OS - Command \1</title>@' \
		-e 's/ style=".*"//g' \
	/tmp/man.html.tmp > $@
	@rm -f /tmp/man.html.tmp

clean:
	@rm -f *~ $(GROFF_FILES) $(HTML_FILES) $(INDEX_FILES)
