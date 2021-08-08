#!/bin/bash -ve
export PORT=${1:-/dev/ttyACM0}
export PROJECT=${2:-./uart_test}
export ZPRJ="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}
export ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-~/zephyr-sdk-0.13.0}

echo Make sure to use the correct ttyACMx...
west flash -d $ZPRJ/build/$PROJECT

