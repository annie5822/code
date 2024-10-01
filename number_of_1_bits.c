#include <stdio.h>
#include <stdint.h>

// Calculate how many leading zeros are in a number."
static inline int my_clz(uint32_t x) {       
    int count = 0;
    for (int i = 31; i >= 0; --i) {     
        if (x & (1U << i))              // 1U = unsigned int 1
            break;
        count++;
    }
    return count;
}


int count_set_bits(uint32_t n) {
    int count = 0;
    while (n != 0) {
        int leading_zeros = my_clz(n); 
        n <<= leading_zeros;          
        if (n != 0) {
            count++;
            n <<= 1;
        }
    }
    return count;
}

int main() {
    uint32_t value1 = 11;
    int set_bits1 = count_set_bits(value1);
    
    uint32_t value2 = 128;
    int set_bits2 = count_set_bits(value2);
    
    uint32_t value3 = 2147483645;
    int set_bits3 = count_set_bits(value3);

    printf("The number of set bits in %d is: %d\n", value1, set_bits1);
    printf("The number of set bits in %d is: %d\n", value2, set_bits2);
    printf("The number of set bits in %d is: %d\n", value3, set_bits3);

    return 0;
}
