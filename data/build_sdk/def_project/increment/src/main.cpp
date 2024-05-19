#include "NeoPixelConnect.h"
#include <pico/time.h>

#include <stdio.h>
#include "pico/stdlib.h"
#include "pico/stdio_usb.h"
#include "boards/pico.h"


const uint LED_PIN = 25;//PICO_DEFAULT_LED_PIN;

#if 0
//Yd-RP2040
// https://github.com/initdc/YD-RP2040
_NeoPixelConnect p(23, MAXIMUM_NUM_NEOPIXELS, pio0, 0);
#else
//RP2040-Zero
// https://www.waveshare.com/wiki/RP2040-Zero
_NeoPixelConnect p(16, MAXIMUM_NUM_NEOPIXELS, pio0, 0);
#endif


int main()
{
    stdio_init_all();
	stdio_set_driver_enabled(&stdio_usb, true);
	
	gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);
	int count = 0;
	
	while(true)
	{
gpio_put(LED_PIN, 1);
	    p.neoPixelFill(255, 0, 0, true);
	    sleep_ms(1000);
//	    p.neoPixelClear(true);
//	    sleep_ms(1000);
gpio_put(LED_PIN, 0);
	    p.neoPixelFill(0, 255, 0, true);
	    sleep_ms(1000);
//	    p.neoPixelClear(true);
//	    sleep_ms(1000);
gpio_put(LED_PIN, 1);
	    p.neoPixelFill(0, 0, 255, true);
	    sleep_ms(1000);
//	    p.neoPixelClear(true);
	    printf("next v '%u'\r\n", count++ );
gpio_put(LED_PIN, 0);
        sleep_ms(1000);

	}
    return 0;
}