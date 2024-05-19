#include <stdio.h>
#include "pico/stdlib.h"
#include "pico/stdio_usb.h"
#include "boards/pico.h"

int main() {
	stdio_init_all();
	stdio_set_driver_enabled(&stdio_usb, true);
	
    const uint LED_PIN = 25;//PICO_DEFAULT_LED_PIN;
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);
    while (true)
    {
        gpio_put(LED_PIN, 1);
        sleep_ms(500);
        gpio_put(LED_PIN, 0);
        sleep_ms(500);
    }
    return 0;
} 
 