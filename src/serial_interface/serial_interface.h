#ifndef SERIAL_INTERFACE_H
#define SERIAL_INTERFACE_H

#include <stdint.h>  // Standard integer types (MISRA C recommends using fixed-width types)

/* Serial interface structure to hold Serial Config */
typedef struct 
{
    uint32_t baudrate;
    uint8_t parity;   // 0: None, 1: Odd, 2: Even
    uint8_t stop_bits; // 1 or 2 stop bits
} SerialConfig;

/* Serial interface structure to hold function pointers */
typedef struct 
{
    void (*init)(uint32_t baudrate);
    void (*transmit)(const uint8_t *data, uint32_t length);
    uint32_t (*receive)(uint8_t *data, uint32_t length);
    uint32_t (*get_status)(void);
    void (*clear_errors)(void);
} SerialInterface;

#endif