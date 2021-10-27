/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr.h>
#include <device.h>
#include <devicetree.h>
#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <stdio.h>

#include <usb/usb_device.h>
#include <logging/log.h>
LOG_MODULE_REGISTER(cdc_acm_echo, LOG_LEVEL_INF);
/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   200

/* The devicetree node identifier for the "led0" alias. */
#define LED0_NODE DT_ALIAS(led0)

#define UART0 DT_ALIAS(sercom_2) 
#if DT_NODE_HAS_STATUS(LED0_NODE, okay)
#define LED0	DT_GPIO_LABEL(LED0_NODE, gpios)
#define PIN	DT_GPIO_PIN(LED0_NODE, gpios)
#define FLAGS	DT_GPIO_FLAGS(LED0_NODE, gpios)
#else
/* A build error here means your board isn't set up to blink an LED. */
#error "Unsupported board: led0 devicetree alias is not defined"
#define LED0	""
#define PIN	0
#define FLAGS	0
#endif

const struct uart_config uart_cfg = {
		.baudrate = 115200,
		.parity = UART_CFG_PARITY_NONE,
		.stop_bits = UART_CFG_STOP_BITS_1,
		.data_bits = UART_CFG_DATA_BITS_8,
		.flow_ctrl = UART_CFG_FLOW_CTRL_NONE
	};

void main(void)
{
	const struct device *dev;
    const struct device *uart_dev;
    const struct device *usb_dev;
    uint32_t baudrate, dtr = 0U;
	bool led_is_on = true;
	int ret;

	dev = device_get_binding(LED0);
    uart_dev = device_get_binding(DT_LABEL(UART0));
    usb_dev = device_get_binding("CDC_ACM_0");
    if (dev == NULL) {
        LOG_ERR("Builtin LED device not found");
		return;
	}
    // ACM port setup
    if (usb_dev == NULL) {
        LOG_ERR("CDC ACM device not found");
		return;
	}

    ret = usb_enable(NULL);
    if (ret != 0) {
        LOG_ERR("Failed to enable USB");
        return;
    }
    LOG_INF("USB enabled");

	ret = gpio_pin_configure(dev, PIN, GPIO_OUTPUT_ACTIVE | FLAGS);
	if (ret < 0) {
		return;
	}
    LOG_INF("Wait for DTR (Data Terminal Ready)"); 
    while (true) {
        uart_line_ctrl_get(usb_dev, UART_LINE_CTRL_DTR, &dtr);
        if (dtr)
            break;
        else {
            /* Give CPU resources to low priority threads. */
            k_sleep(K_MSEC(100));
        }
    }
    LOG_INF("DTR set");

    /* Wait 1 sec for the host to do all settings */
    k_busy_wait(1000000);

    ret = uart_line_ctrl_get(usb_dev, UART_LINE_CTRL_BAUD_RATE, &baudrate);
    if (ret) {
        LOG_WRN("Failed to get baudrate, ret code %d", ret);
    } else {
        LOG_INF("Baudrate detected: %d", baudrate);
    }
    // END OF ACM port setup

    if (uart_dev == NULL) {
        LOG_ERR("UART0 device not found");
    	return;
    }
    char buf[10];
    ret = uart_configure(uart_dev, &uart_cfg);
    snprintf(buf, 10, "%d", ret);
    LOG_INF("%s", log_strdup(buf));
    if (!device_is_ready(uart_dev)) {
		LOG_WRN("UART device not ready\n");
		return;
	}


    //LOG_HEXDUMP_INF(0, &ret, 1);
    unsigned char rec_char;
	while (1) {
		gpio_pin_set(dev, PIN, (int)led_is_on);
        if (uart_poll_in(uart_dev, &rec_char) == 0)
            LOG_INF("Received char: '%c'", rec_char);
        //if (led_is_on)
        //    uart_poll_out(uart_dev, '1');
        //else
        //    uart_poll_out(uart_dev, '0');
		led_is_on = !led_is_on;
		k_msleep(SLEEP_TIME_MS);
	}
}
