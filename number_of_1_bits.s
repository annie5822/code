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
    add t1, zero, zero                # reset t1 to zero
    add t2, zero, zero                # reset t2 to zero
    addi t2, t2, 1                    # t2 = 1  (t2 is 1U)
    mv s1, a0                         # without modifying a0, copy a0 to s1
    bnez s1, count_set_bits_loop      # while (n != 0) 
here3:
    jal ra,clz_done
    
    li a7, 10                         # close the program
    ecall

clz_loop:
    sll t4, t2, t1                    # t4 record 1U shift i
    addi t1, t1, -1                   # i = i - 1
    and t4, t4, s1                    # x & (1U << i)
    bnez t4, clz_record               # break
    
    addi t5, t5, 1                    # did not enter the if statement and incremented count
    bge t1, zero, clz_loop            # return to the clz_loop
    
count_set_bits_loop:                  # s0 is count
    
    add t1, zero, zero                # clz_loop i reset to 0
    addi t1, t1, 31                   # t1 = 31 (t1 is i)
    jal ra, clz_loop                  # leading_zeros = my_clz(n);
here1:   
    sll s1, s1, s3                    # n <<= leading_zeros;
    bnez s1, count_set_bits_if_statement
here2:
    bnez s1, count_set_bits_loop      
    beq s1,zero,here3
    
    
clz_record:                           # s3 is leading_zeros in count_set_bits_loop
    mv s3, t5                         
    add t5, zero, zero
    jal here1
    # want to jump to 52 lines  
    
count_set_bits_if_statement:
    addi s2, s2, 1
    slli s1, s1, 1
    jal here2

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
