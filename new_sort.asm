##########################################################################################
# C pseudocode for descending order sorting the sid digital numbers.
##########################################################################################
#   sortedsid = sid;
#   mask0 = 0x0f;
#   each iteration selects the smallest digital number from the unprocessed digital numbers
#   for (int i= 0; i < 8; i++) {
#       a = sortedsid & mask0;
#       a = a >> (4 * i);
#       mask1 = mask0 << 4;
#       bestj = i;
#       tmpMin = a;
#     for (int j = i + 1; j < 8) {
#       b = sortedsid & mask1;
#       b = b >> (4 * j);
#       if (tmpMin > b) {
#          tmpMin = b;
#          bestj = j;
#       }
#       mask1 = mask1 << 4;
#     }
#     if (a > tmpMin) {
#         mask1 = 0x0f;
#         bestj4 = bestj << 2;
#         mask1 = mask1 << bestj4
#         mask2 = mask0 | mask1;
#         mask2 = ~mask2;
#         sortedsid = sortedsid & mask2;
#         tmpMax = tmpMax << (4 * i);
#         sortedsid = sortedsid | tmpMax;
#         a = a << bestj4;
#         sortedsid = sortedsid | a;
#       }
#     mask0 = mask0 << 4;
#   }
##########################################################################################
# the uasge of the registers
##########################################################################################
# mem[0x180], student id.
# mem[0x184], sorted student id
# $1, partially sorted student number / the address of switch
# $2, the outer loop variable i / the address of seg7
# $3, the inner loop variable j / the switch input
# $4, mask0
# $5, mask1
# $6, mask2
# $7, a
# $8, b
# $9, 4 * i
# $10, 4 * j
# $11, N = 8
# $12, bestj
# $13, tmpMin
# $14, compare result
##########################################################################################
lui     $2, 0x0218          #  high halfword the student id (last 8 digitals), use your own student id. instead!
ori     $2, $2, 0x1069      #  low halfword of the student id (last 8 digitals)
sw      $2, 0x180($0)       # store the original sid at data memory
addi    $11, $0, 8          #  the size of sid, N = 8
lw      $1, 0x180($0)       # $1 = [0x180] = sid

addi    $2, $0, 0           # i = 0, the start index of the array
addi    $3, $11, -1         # j = N - 1, the end index of the array

jal     quicksort           # call the quicksort function

# Quicksort function
quicksort:
    beq     $2, $3, end_quicksort   # if (i == j), the array has only one element, return

    add     $5, $2, $0       # $5 = i, the start index of the array
    add     $6, $3, $0       # $6 = j, the end index of the array

    sll     $7, $2, 2        # $7 = i * 4, the offset of the pivot element
    add     $8, $1, $7       # $8 = &sid[i]
    lw      $9, 0($8)        # $9 = sid[i], the pivot element

partition:
    ble     $5, $6, swap_elements   # if (i <= j), continue partitioning
    j       end_partition

swap_elements:
    sll     $10, $5, 2       # $10 = i * 4, the offset of the left element
    sll     $11, $6, 2       # $11 = j * 4, the offset of the right element

    add     $12, $1, $10     # $12 = &sid[i]
    lw      $13, 0($12)      # $13 = sid[i], the left element

    add     $12, $1, $11     # $12 = &sid[j]
    lw      $14, 0($12)      # $14 = sid[j], the right element

    ble     $13, $9, increment_i    # if (sid[i] <= pivot), increment i
    bgt     $14, $9, decrement_j    # if (sid[j] > pivot), decrement j

    swap_elements_helper:   # swap sid[i] and sid[j]
        sw      $14, 0($8)
        sw      $13, 0($12)

    increment_i:
        addi    $5, $5, 1
        j       partition

    decrement_j:
        addi    $6, $6, -1
        j       partition

end_partition:
    addi    $2, $2, 1       # i++
    addi    $3, $3, -1      # j--

    jal     quicksort       # recursively call quicksort for the two partitions

end_quicksort:
    jr      $ra             # return