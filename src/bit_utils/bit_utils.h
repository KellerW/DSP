#ifndef BIT_UTILS_H
#define BIT_UTILS_H

#include <stdint.h>  // Standard integer types (MISRA C recommends using fixed-width types)
#include <limits.h>
uint8_t set_bit(uint8_t reg, uint8_t bit);
uint8_t clear_bit(uint8_t reg, uint8_t bit);
uint8_t toggle_bit (uint8_t reg, uint8_t bit);
uint8_t pow2(uint8_t base, uint8_t exp);

//uint32_t bit_swap_ranges(uint32_t num, uint8_t p1, uint8_t p2, uint8_t n1, uint8_t n2);




#endif