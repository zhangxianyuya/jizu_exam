# Test the MIPS processor in simulation
# add, sub, and, or, slt, addi, lw, sw, beq, j, jal
# If successful, it should write the value 7 to address 256, 260

#       Assembly                  Description           Instr   Address Machine
main:   addi $2, $0, 5          # initialize $2 = 5     00      0       20020005
        addi $3, $0, 12         # initialize $3 = 12    01      4       2003000c
        addi $7, $3, -9         # initialize $7 = 3     02      8       2067fff7
        or   $4, $7, $2         # $4 = (3 or 5) = 7     03      c       00e22025
        and  $5, $3, $4         # $5 = (12 and 7) = 4   04      10      00642824
        add  $5, $5, $4         # $5 = 4 + 7 = 11       05      14      00a42820
        beq  $5, $7, label2     # shouldn't  be taken       06      18      10a7000a
        			# if it is 'bne',should be taken, adr [256] != 7
        slt  $4, $3, $4         # $4 = (12 < 7) = 0     07      1c      0064202a
        beq  $4, $0, label1     # should be taken       08      20      10800001
        addi $5, $0, 0          # shouldn't happen      09      24      20050000
label1: slt  $4, $7, $2         # $4 = (3 < 5) = 1      0A      28      00e2202a
        add  $7, $4, $5         # $7 = 1 + 11 = 12      0B      2c      00853820
        sub  $7, $7, $2         # $7 = 12 - 5 = 7       0C      30      00e23822
        sw   $7, 244($3)        # [256] = 7             0D      34      ac6700f4
        lw   $2, 256($0)        # $2 = [256] = 7        0E      38      8c020100
        jal  label2             # should be taken       0F      3c      0c000011
        addi $2, $0, 1          # shouldn't happen      10      40      20020001
label2: sw   $2, 260($0)        # write adr 260 = 7     11      44      ac020104
#SLL rd, rt, sa	
	#sw   $7, 264($0)	#adr [264] = $5<<2 
#NOR rd, rs, rt	
	#nor  $3, $0, $4		
	#sw   $3, 268($0)	#adr [268] = 0xfffffffe
#LUI rt, immediate
	#lui  $4, 17
	#sw   $4, 252($0)	#adr [254] = 0x00110000		
#SLTI rt, rs, immediate
	#slti $4, $2, 80
	#sw   $4, 272($0)	#adr [272] = 0x00000001
#ANDI rt, rs, immediate
	andi  $3, $2, 27
	sw    $3, 276($0)	#adr [276] = 0x00000003
#SRL rd, rt, sa
	#srl   $5, $3, 1
	#sw    $5, 280($0)	#adr [280] = 0x00000001
#SLLV rd, rt, rs
	sllv  $3, $2, $7
	sw    $3, 284($0)	#adr [284] = 0x00000380
	srlv  $2, $3, $7
	sw    $2, 284($0)	#adr [284] = 0x00000007
#JR rs
	sll   $5, $4, 2
	jalr  $5
	sll   $5, $4, 4
	jr    $5
	

loop:   j    loop               # dead loop             12      48      08000012

# $0  = 0  # $1  = 0  # $2  = 7  # $3  = c
# $4  = 1  # $5  = b  # $7  = 7  # $31 = 40
# [0x100] = 7  [0x104] = 7

