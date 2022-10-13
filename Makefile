Q ?= @
CC = arm-none-eabi-gcc
NWLINK = nwlink
LINK_GC = 1
LTO = 1

objs = $(addprefix output/lua/,\
  lapi.o \
  lauxlib.o \
  lbaselib.o \
  lcode.o \
  lcorolib.o \
  lctype.o \
  ldblib.o \
  ldebug.o \
  ldo.o \
  ldump.o \
  lfunc.o \
  lgc.o \
  linit.o \
  liolib.o \
  llex.o \
  lmathlib.o \
  lmem.o \
  loadlib.o \
  lobject.o \
  lopcodes.o \
  loslib.o \
  lparser.o \
  lstate.o \
  lstring.o \
  lstrlib.o \
  ltable.o \
  ltablib.o \
  ltm.o \
  lundump.o \
  lutf8lib.o \
  lvm.o \
  lzio.o \
)

objs += $(addprefix output/,\
  eadk_lib.o \
  icon.o \
  main.o \
)

CFLAGS = -std=c99
CFLAGS += $(shell $(NWLINK) eadk-cflags)
CFLAGS += -Os -Wall
CFLAGS += -ggdb
CFLAGS += -Isrc/lua
LDFLAGS = -Wl,--relocatable
LDFLAGS += -nostartfiles
LDFLAGS += --specs=nosys.specs
# LDFLAGS += --specs=nosys.specs # Alternatively, use full-fledged newlib

ifeq ($(LINK_GC),1)
CFLAGS += -fdata-sections -ffunction-sections
LDFLAGS += -Wl,-e,main -Wl,-u,eadk_app_name -Wl,-u,eadk_app_icon -Wl,-u,eadk_api_level
LDFLAGS += -Wl,--gc-sections
endif

ifeq ($(LTO),1)
CFLAGS += -flto -fno-fat-lto-objects
CFLAGS += -fwhole-program
CFLAGS += -fvisibility=internal
LDFLAGS += -flinker-output=nolto-rel
endif

.PHONY: build
build: output/lua.nwa

.PHONY: check
check: output/lua.bin

.PHONY: run
run: output/lua.nwa src/test.lua
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa --external-data src/test.lua $<

output/%.bin: output/%.nwa src/test.lua
	@echo "BIN     $@"
	$(Q) $(NWLINK) nwa-bin --external-data src/test.lua $< $@

output/%.elf: output/%.nwa src/test.lua
	@echo "ELF     $@"
	$(Q) $(NWLINK) nwa-elf --external-data src/test.lua $< $@

output/lua.nwa: $(objs)
	@echo "LD      $@"
	$(Q) $(CC) $(CFLAGS) $(LDFLAGS) $^ -lm -o $@

output/%.o: src/%.c
	@mkdir -p $(@D)
	@echo "CC      $^"
	$(Q) $(CC) $(CFLAGS) -c $^ -o $@

output/icon.o: src/icon.png
	@echo "ICON    $<"
	$(Q) $(NWLINK) png-icon-o $< $@

.PHONY: clean
clean:
	@echo "CLEAN"
	$(Q) rm -rf output
