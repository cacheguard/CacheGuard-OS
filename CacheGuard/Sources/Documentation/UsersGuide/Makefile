include CacheGuard.env

GUIDE_FILES := $(shell ls -1 *.html 2> /dev/null)
HTML_FILES =  $(GUIDE_FILES:%.html=$(HTML_GENERATED_DIR)/%.html)

all: $(HTML_GENERATED_DIR)/installation.html $(HTML_FILES)

$(HTML_GENERATED_DIR)/installation.html: Installation/installation-1.html Installation/installation-2.html Installation/machine-requirements ../../../CacheGuard.env-1 index.html gen-guide-page.bash Makefile
	@mkdir -p $(HTML_GENERATED_DIR)
	@./gen-guide-page.bash installation.html noindex > $@
	@cat Installation/installation-1.html >> $@
	@cat Installation/machine-requirements >> $@
	@cat Installation/installation-2.html >> $@
	@echo "</div>" >> $@
	@cat copyright >> $@
	@echo "</body>" >> $@
	@echo "</html>" >> $@

$(HTML_GENERATED_DIR)/%.html: %.html ../../../CacheGuard.env-1 index.html gen-guide-page.bash Makefile
	@mkdir -p $(HTML_GENERATED_DIR)
	@./gen-guide-page.bash $< noindex > $@
	@cat $< >> $@
	@echo "</div>" >> $@
	@cat copyright >> $@
	@echo "</body>" >> $@
	@echo "</html>" >> $@

clean:
	@rm -f *~ $(HTML_GENERATED_DIR)/*
