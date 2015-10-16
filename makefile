# libraries are read from a file named libraries

cc ?= gcc
ccc ?= g++

node = ${shell node -e $(1)}
opts = ${call node, "var o = require('./package.json').$(1); if(Array.isArray(o)) o = o.join(' '); console.log(o);"}
paths = ${call node, "console.log(module.paths.join(' '));"}



includes = ${paths} /usr/include/node

flags = ${addprefix -I, ${includes}} -fPIC -DPIC -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -DEV_MULTIPLICITY=0

cflags =
cflags_debug = -g -Wall
cflags_release = -O3

ccflags =
ccflags_debug = -g -Wall
ccflags_release = -O3

csources = ${wildcard src/*.c}
ccsources = ${wildcard src/*.cc}
libraries = ${addprefix -l, ${call opts, libraries}}
target = ${call opts, name}
version = ${call opts, version}

.phony: all clean dirs

all: debug

release: dirs ${csources:.c=.c.lib.o} ${ccsources:.cc=.cc.lib.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared ${addprefix build/, ${csources:.c=.c.lib.o}} ${libraries} -o build/release.node
else
	@${ccc} -shared ${addprefix build/, ${csources:.c=.c.lib.o}} ${addprefix build/, ${ccsources:.cc=.cc.lib.o}} ${libraries} -o build/release.node
endif

debug: dirs ${csources:.c=.c.lib.debug.o} ${ccsources:.cc=.cc.lib.debug.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared ${addprefix build/, ${csources:.c=.c.lib.debug.o}} ${libraries} -o build/debug.node
else
	@${ccc} -shared ${addprefix build/, ${csources:.c=.c.lib.debug.o}} ${addprefix build/, ${ccsources:.cc=.cc.lib.debug.o}} ${libraries} -o build/debug.node
endif

%.c.lib.debug.o: %.c
	@${cc} ${flags} ${cflags} ${cflags_debug} -c $< -o build/$@
%.cc.lib.debug.o: %.cc
	@${ccc} ${flags} ${ccflags} ${ccflags_debug} -c $< -o build/$@
%.c.lib.o: %.c
	@${cc} ${flags} ${cflags} ${cflags_release} -c $< -o build/$@
%.cc.lib.o: %.cc
	@${ccc} ${flags} ${ccflags} ${ccflags_release} -c $< -o build/$@

dirs:
	@mkdir -p build/${dir ${csources}}
	@mkdir -p build/${dir ${ccsources}}

clean:
	-@rm -rf build