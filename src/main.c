
#include "strings.h"
#include "serial_interface.h"
#include "bit_utils.h"
#include <stdint.h>
//#include <stdio.h>

volatile uint8_t * inptreg = (volatile uint8_t *) 0xFF;
#define RCC_BASE 0x40021000
#define GPIOC_BASE 0x40011000

#define RCC_APB2ENR (*(volatile uint32_t *)(RCC_BASE + 0x18))
#define GPIOC_CRH   (*(volatile uint32_t *)(GPIOC_BASE + 0x04))
#define GPIOC_ODR   (*(volatile uint32_t *)(GPIOC_BASE + 0x0C))

void delay(volatile uint32_t count) {
    while (count--) {
        __asm__ volatile ("nop");
    }
}

int main (void)
{
    // Enable clock for GPIOC
    RCC_APB2ENR |= (1 << 4);

    // Configure PC13 as output (push-pull, 2MHz)
    GPIOC_CRH &= ~(0xF << 20);  // Clear bits for PC13
    GPIOC_CRH |= (0x2 << 20);   // Set mode to output 2 MHz

    while (1) {
        GPIOC_ODR &= ~(1 << 13);  // Turn on LED (PC13 low)
        delay(500000);

        GPIOC_ODR |= (1 << 13);   // Turn off LED (PC13 high)
        delay(500000);
    }

    return 0;
}





