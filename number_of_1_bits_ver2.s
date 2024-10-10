.data
argument1:  .word 11
argument2:  .word 128
argument3:  .word 2147483645
msg1:       .string "The number of set bits in "
msg2:       .string " is : "
endl:       .string "\n"

.text
main:
    la s5, argument1                  # s5 store address
    li s6, 3                          # s6 store test number
loop:
    lw a0, 0(s5)                      # a0 = argument1
    add s2, zero, zero                # reset bit_loop's count to zero
    mv s1, a0                         # without modifying a0, copy a0 to s1
    beq s1, zero, clz_done     
count_set_bits_loop:
clz_loop:
    add t0, zero, zero
    srli t1, s1, 1
    or t0, t1, s1     
    srli t1, t0, 2
    or t0, t1, t0
    srli t1, t0, 4
    or t0, t1, t0
    srli t1, t0, 8
    or t0, t1, t0
    srli t1, t0, 16
    or t0, t1, t0
    # x -= ((x >> 1) & 0x55555555); 
    srli t1, t0, 1
    li t2, 0x55555555
    and t1, t1, t2
    sub t0, t0,t1
    # x = ((x >> 2) & 0x33333333) + (x & 0x33333333); 
    srli t1, t0, 2
    li t2, 0x33333333
    and t1, t1, t2
    and t0, t0, t2
    add t0, t0, t1
    # x = ((x >> 4) + x) & 0x0f0f0f0f;
    srli t1, t0, 4
    add t1, t0, t1
    li t2, 0x0f0f0f0f
    and t0, t1, t2
    # x += (x >> 8);
    srli t1, t0, 8
    add t0, t0, t1
    # x += (x >> 16);
    srli t1, t0, 16
    add t0, t0, t1
    # t0 = (32 - (x & 0x3f))
    li t2, 0x3f
    and t0, t0, t2
    sub t0, zero, t0
    addi t0, t0, 32                   # t0 = leading_zero
    
back_to_bits_loop:   
    sll s1, s1, t0                    # n <<= leading_zeros;
    bnez s1, count_set_bits_if_statement
    
judge:
    bnez s1, count_set_bits_loop      
    beq s1, zero, clz_done
    
count_set_bits_if_statement:
    addi s2, s2, 1
    slli s1, s1, 1
    jal x0, judge

clz_done:
    mv s1, a0
    
    la a0, msg1                        # print "The number of set bits in "
    li a7, 4
    ecall
    
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, msg2                        # print " is : "
    li a7, 4
    ecall 
    
    mv a0, s2
    li a7, 1
    ecall
    
    la a0, endl                        # print " \n "
    li a7, 4
    ecall 

    addi s5, s5, 4                     # move to the next test case
    addi s6, s6, -1                    # test case counter--
    bne  s6, zero, loop                # counter=0,break
    
    li a7, 10                          # close the program
    ecall
