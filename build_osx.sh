#!/usr/bin/env bash

mkdir -p ./Plugins

cd macnojit/
xcodebuild clean
xcodebuild -configuration=Release
cp -r build/Release/tolua.bundle ../Plugins/
