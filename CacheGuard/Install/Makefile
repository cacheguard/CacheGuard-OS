include CacheGuard.env

OS_DIR=OS
PATCH_DIR=Patch

LIC_DIR=../Sources/Documentation/OnlineCommands/$(GENERATED_DIR)

all: $(GENERATED_DIR)/CGL.txt

$(GENERATED_DIR)/CGL.txt: $(LIC_DIR)/license.1 Makefile
	@echo Generating ASCII License...
	@groff -man -Tascii $< | sed -e 's/[\x08].//g' > $(GENERATED_DIR)/CGL.txt

clean:
	@rm -f *~ $(GENERATED_DIR)/CGL.txt
