#include "unity.h"
#include "bit_utils.h"
void setUp(void) {} // Empty setUp function
void tearDown(void) {} // Empty tearDown function



void test_pow2(void) 
{
    TEST_ASSERT_EQUAL(4, pow2(2,1)); 
}

void test_lear_bit(void) 
{
    TEST_ASSERT_EQUAL(0, clear_bit(2,1)); 
}



int main(void) 
{
    UNITY_BEGIN();
    RUN_TEST(test_pow2);
    RUN_TEST(test_lear_bit);
    return UNITY_END();
}