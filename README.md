# Lua

[![Build](https://github.com/nwagyu/lua/actions/workflows/build.yml/badge.svg)](https://github.com/nwagyu/lua/actions/workflows/build.yml)

This apps lets you run [Lua](https://www.lua.org/about.html) scripts on your [NumWorks calculator](https://www.numworks.com).

## Install the app

Installing is rather easy:
1. Download the latest `lua.nwa` file from the [Releases](https://github.com/nwagyu/lua/releases) page
2. Head to [my.numworks.com/apps](https://my.numworks.com/apps) to send the `nwa` file on your calculator. On this page you will be able to add the Lua script you want to execute.

## How to use the app

Just launch the app and execute your script.

## Dependencies

This programs uses Lua version 5.4.4.

## Build the app

To build this sample app, you will need to install the [embedded ARM toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) and [nwlink](https://www.npmjs.com/package/nwlink).

```shell
brew install numworks/tap/arm-none-eabi-gcc node # Or equivalent on your OS
npm install -g nwlink
make clean && make build
```
