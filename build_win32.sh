#!/bin/bash
# 32 Bit Version
mkdir -p window/x86

cd luajit
mingw32-make clean

mingw32-make BUILDMODE=static CC="gcc -m32 -O3"
cp src/libluajit.a ../window/x86/libluajit.a
mingw32-make clean

cd ../pbc/
make clean
make BUILDMODE=static CC="gcc -m32"
cp build/libpbc.a ../window/x86/libpbc.a

cd ../cjson/
make clean
make BUILDMODE=static CC="gcc -m32"
cp build/libcjson.a ../window/x86/libcjson.a

cd ..

gcc -m32 -O3 -std=gnu99 -shared \
	int64.c \
	uint64.c \
	tolua.c \
	pb.c \
	lpeg.c \
	struct.c \
	cjson/strbuf.c \
	cjson/lua_cjson.c \
	cjson/fpconv.c \
	luasocket/auxiliar.c \
	luasocket/buffer.c \
	luasocket/except.c \
	luasocket/inet.c \
	luasocket/io.c \
	luasocket/luasocket.c \
	luasocket/mime.c \
	luasocket/options.c \
	luasocket/select.c \
	luasocket/tcp.c \
	luasocket/timeout.c \
	luasocket/udp.c \
	luasocket/wsocket.c \
	luasocket/compat.c \
	sproto/sproto.c \
	sproto/lsproto.c \
	pbc/binding/lua/pbc-lua.c \	
	-o Plugins/x86/tolua.dll \
	-I./ \
	-Iluajit/src \
	-Iluasocket \
	-Isproto \
	-Ipbc \
	-Icjson \
	-lws2_32 \
	-Wl,--whole-archive \
	window/x86/libluajit.a \
	window/x86/libpbc.a \
	window/x86/libcjson.a -Wl,--no-whole-archive -static-libgcc -static-libstdc++
