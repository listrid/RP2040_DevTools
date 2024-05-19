# Import SDK
cmake_minimum_required(VERSION 3.13)
include($ENV{PICO_SDK_PATH}/pico_sdk_init.cmake)
include($ENV{PICO_SDK_TOOLS_PATH}/pico-sdk-tools-config.cmake)
pico_sdk_init()

project(pico)


add_library(pico SHARED)

# Debug output - Enable for USB CDC and disable for on-board UART
# You can change these around (or even have both active) by changing the 1s and 0s
pico_enable_stdio_usb(pico $ENV{STDOUT_USB})
pico_enable_stdio_uart(pico $ENV{STDOUT_UART})
pico_enable_stdio_semihosting(pico $ENV{STDOUT_SEMIHOSTING})


# Build dependencies and link application

target_link_libraries(pico
 pico_stdlib
 hardware_spi
 pico_rand
 pico_flash
 pico_multicore
 pico_i2c_slave
 hardware_pio
 hardware_i2c
 hardware_dma
 pico_async_context_base
 hardware_rtc
 hardware_adc
 hardware_exception
 boot_stage2_headers
)

