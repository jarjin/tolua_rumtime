CC = gcc
CFLAGS = -O2 -fPIC -Wall 
AR = ar rc

BUILD = build

.PHONY : all lib clean tool

LIBSRCS = fpconv.c strbuf.c 
LIBNAME = libcjson.a

BUILD_O = $(BUILD)/o

all : lib 

lib : $(LIBNAME)

clean :
	rm -rf $(BUILD)

$(BUILD) : $(BUILD_O)

$(BUILD_O) :
	mkdir -p $@

TOOL := $(BUILD)/dump

tool : $(TOOL)

$(TOOL) : | $(BUILD)
$(TOOL) : $(LIBNAME)
$(TOOL) : tool/dump.c
	cd $(BUILD) && $(CC) $(CFLAGS) -I.. -L. -o dump ../$< -lpbc

LIB_O :=

define BUILD_temp
  TAR :=  $(BUILD_O)/$(notdir $(basename $(1)))
  LIB_O := $(LIB_O) $$(TAR).o
  $$(TAR).o : | $(BUILD_O)
  -include $$(TAR).d
  $$(TAR).o : $(1)
	$(CC) $(CFLAGS) -c -Isrc -I. -o $$@ -MMD $$<
endef

$(foreach s,$(LIBSRCS),$(eval $(call BUILD_temp,$(s))))

$(LIBNAME) : $(LIB_O)
	cd $(BUILD) && $(AR) $(LIBNAME) $(addprefix ../,$^)

TEST :=

define TEST_temp
  TAR :=  $(BUILD)/$(notdir $(basename $(1)))
  TEST := $(TEST) $$(TAR)
  $$(TAR) : | $(BUILD)
  $$(TAR) : $(LIBNAME)
  $$(TAR) : test/$(1) 
	cd $(BUILD) && $(CC) $(CFLAGS) -I.. -L. -o $$(notdir $$@) ../$$< -lpbc
endef

$(foreach s,$(TESTSRCS),$(eval $(call TEST_temp,$(s))))

test : $(TEST) proto

PROTO :=

define PROTO_temp
  TAR :=  $(BUILD)/$(notdir $(basename $(1)))
  PROTO := $(PROTO) $$(TAR).pb
  $$(TAR).pb : | $(BUILD)
  $$(TAR).pb : test/$(1)
	protoc -o$$@ $$<
endef

$(foreach s,$(PROTOSRCS),$(eval $(call PROTO_temp,$(s))))

proto : $(PROTO)

.PHONY : all lib test proto clean

