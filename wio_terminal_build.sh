#!/bin/bash -xe
export ZPRJ="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}
export ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-~/zephyr-sdk-0.13.0}
#export ZEPHYR_EXTRA_MODULES=${ZEPHYR_EXTRA_MODULES:-"$ZPRJ/greybus-for-zephyr-mikrobus:$ZPRJ/sensortest/sgp30"}
#export ZEPHYR_EXTRA_MODULES=${ZEPHYR_EXTRA_MODULES:-"$ZPRJ/greybus-for-zephyr-mikrobus"}

# CC1352
cd $ZPRJ


west build -p always -b wio_terminal $ZPRJ/samples/basic/blinky -d blinky_test
west build -p always -b wio_terminal $ZPRJ/uart_arduino_test -d uart_test 
#west build -p always -b beagleconnect_freedom $ZPRJ/sensortest -d $ZEPHYR_BASE/build/sensortest_beagleconnect -- -DOVERLAY_CONFIG=overlay-subghz.conf -DBOARD_ROOT=$ZPRJ/wpanusb_bc -DCONFIG_NET_CONFIG_IEEE802154_RADIO_TX_POWER=14 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_DIV_SETUP_PA=1 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_CS_THRESHOLD=-20

#west build -p always -b beagleconnect_freedom $ZPRJ/greybus-for-zephyr-mikrobus/samples/subsys/greybus/net -d build/greybus_mikrobus_beagleconnect -- -DOVERLAY_CONFIG=overlay-802154-subg.conf -DCONFIG_NET_CONFIG_IEEE802154_RADIO_TX_POWER=14 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_DIV_SETUP_PA=1 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_CS_THRESHOLD=-20 -DBOARD_ROOT=$ZPRJ/wpanusb_bc

#west build -p always -b beagleconnect_freedom $ZPRJ/blinkytest -d $ZEPHYR_BASE/build/blinky_test -- -DOVERLAY_CONFIG=overlay-subghz.conf -DBOARD_ROOT=$ZPRJ/wpanusb_bc -DCONFIG_NET_CONFIG_IEEE802154_RADIO_TX_POWER=14 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_DIV_SETUP_PA=1 -DCONFIG_IEEE802154_CC13XX_CC26XX_SUB_GHZ_CS_THRESHOLD=-20

