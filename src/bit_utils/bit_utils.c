#include "bit_utils.h"

uint8_t set_bit(uint8_t reg, uint8_t bit)
{
   uint8_t mask = 1 << bit;
   uint8_t ret = reg | mask;
   return ret;
}

uint8_t clear_bit(uint8_t reg, uint8_t bit)
{
   uint8_t mask = ~(1 << bit);
   uint8_t ret = reg & mask;
   return ret;
}

uint8_t toggle_bit (uint8_t reg, uint8_t bit)
{
   uint8_t mask = 1 << bit;
   uint8_t ret = reg ^ mask;
   return ret;
}   

uint8_t pow2(uint8_t base, uint8_t exp)
{
    uint8_t ret = 0;
    if(exp >= CHAR_BIT)
        ret = UINT8_MAX;
    else
        ret = base << exp;
    return ret;
}

// uint32_t bit_swap_ranges(uint32_t num, uint8_t p1, uint8_t p2, uint8_t n1, uint8_t n2)
// {




// }