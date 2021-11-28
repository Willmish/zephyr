#!/bin/bash -xe
export ZPRJ="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}
export ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-~/zephyr-sdk-0.13.0}

cd $ZPRJ


west build -p always -b wio_terminal $ZPRJ/samples/basic/blinky -d blinky_test
west build -p always -b wio_terminal $ZPRJ/uart_arduino_test -d uart_test -- -DDTC_OVERLAY_FILE=usb.overlay

