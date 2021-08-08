.. _uart-test:

UART test
######

Overview
********

This program opens a ttyACM port using CDC ACM after which it listens to messages incoming on UART and logs them to the ttyACM port.

CURRENTLY does not work, uart_poll_in() keeps returning 0 and no meaningful characters get through, even when no characters are sent to its RX pin.
.. _uart-test-requirements:

Requirements
************

In order to run the demo:
-Wio Terminal TX/RX connected to Beagleconnect/UART device RX/TX. Both devices connected to common ground.
-Flash the program to the Wio Terminal
-open a serial monitior to the port created by Wio Terminal (/dev/ttyACM0 by default)
-Flash `uart_test` program on the beagleconnect/UART device. (found here: https://github.com/Willmish/beagleconnect/tree/master/sw/zephyrproject/uart_test)
-Open a serial monitor to the port created by the beagleconnect/UART device (/dev/ttyACM0 by default, will be /dev/ttyACM1 if plugged in after Wio Terminal)

Building and Running
********************

to build and flash the program, use the supplied flashing scripts: 

BUILDING:
https://github.com/Willmish/zephyr/blob/wio_terminal_support/wio_terminal_build.sh

FLASHING:
https://github.com/Willmish/zephyr/blob/wio_terminal_support/wio_terminal_flash_uart_test.sh
