
.data
displayAddress: .word 0x10008000

frog_x: .word 16

frog_y: .word 26

lives: .space 4

goal1: .space 4

goal2: .space 4

goal3: .space 4 #initially all contain 0 until they get filled with 1

num_goals: .space 4 #initially this will be 0, this counts the score aka the number of goals filled

frog_direction: .space 4 #initially set to 0, frog stationary, becomes 1, 2, 3, 4 depending on keyboard input

sound: .space 4 #initially 0, means there is no sound

logs: .space 128

logstore: .space 127



message: .asciiz "Game Over! \n"

.text

game:

li $s7, 0 #this is used for the logs iterations


lw $t0, displayAddress #t0 contains the base address for the display

lw $t2, frog_x #t2 contains the x location of the top left corner of the frog
lw $t3, frog_y #t3 contains the y location of the top left corner of the frog


li $s3, 2760 #s3 contains address of the 4th car

li $s2, 2692 #s2 contains address of 3rd car 

li $s1, 2260 #contains address of 2nd car

li $s0, 2192 #contains address of 1st car


#location of the top right corner of the first log
li $s6, 1184


#the location of the top right corner of the second log
li $v1, 1248

#the number of frog lives, start with 3
li $t8, 3
sw $t8, lives($zero)

#the status of the first goal, 0 means unfilled
sw $zero, goal1($zero)

#the status of the second goal, 0 means unfilled
sw $zero, goal2($zero)

#the status of the third goal, 0 means unfilled
sw $zero, goal3($zero)


#fill the frog_direction with 0 at first, stationary frog
sw $zero, frog_direction($zero)

#initialize the number of goals filled, which is 0 initially
sw $zero, num_goals($zero)


main:
#very beginning, set sound to 0
sw $zero, sound($zero)


#start detecting keyboard input
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input
j after_key


#check which letter was pressed
keyboard_input:
lw $t8, 0xffff0004
beq $t8, 0x61, respond_to_A
beq $t8, 0x77, respond_to_W
beq $t8, 0x73, respond_to_S
beq $t8, 0x64, respond_to_D
beq $t8, 0x70, respond_to_P
beq $t8, 0x71, Exit  #if q is pressed, exit the program

j after_key #if neither W, A, S, D were pressed, skip to after_key label


respond_to_A:
addi $t2, $t2, -4
li $t8, 1
sw $t8, frog_direction($zero)

#sound of frog jumping
#we want the sound to become 1
li $t8, 1
sw $t8, sound($zero)

j after_key #after changing x and y, go to after_key

respond_to_W:
addi $t3, $t3, -4
li $t8, 2
sw $t8, frog_direction($zero)

#sound of frog jumping
#we want the sound to become 1
li $t8, 1
sw $t8, sound($zero)


j after_key  #after changing x and y, go to after_key

respond_to_S:
addi $t3, $t3, 4
li $t8, 3
sw $t8, frog_direction($zero)

#sound of frog jumping
#we want the sound to become 1
li $t8, 1
sw $t8, sound($zero)



j after_key   #after changing x and y, go to after_key

respond_to_D:
addi $t2, $t2, 4
li $t8, 4
sw $t8, frog_direction($zero)

#sound of frog jumping
#we want the sound to become 1
li $t8, 1
sw $t8, sound($zero)

j after_key  #after changing x and y, go to after_key


respond_to_P:
j pause_loop

after_key: #after the x and y are changed from keyboard input



#we will do 4((32)(y-1) + x) to get the position of the top left corner of the frog on the display
addi $t4, $t3, -1  #subtract 1 from y

li $t7, 32 #load 32 into t9

mult $t4, $t7 #multiply (y - 1) by 32

mflo $t6 #store result in t6

add $t6, $t6, $t2 # add 32(y - 1) + x

li $t7, 4 #load 4 into t9

mult $t7, $t6 #multiply 4 by (32(y-1) + x)

mflo $a0  #store result in t6


#initialize the loop variables t8 and t7, paints the finishing grass safe area
li $t8, 0 #initially set t8 to 0
li $t7, 160 #set t7 to 160
li $t1, 0x00ff00  #change t1 back to green

#call to the function to make the grass
jal paintgreen


#THIS IS THE SCORE
lw $t8, num_goals($zero)
#display score aka num of goals filled
#we first check what values are stored inside the registers
beq $t8, 3, make3_score

beq $t8, 2, make2_score

beq $t8, 1, make1_score

beq $t8, 0, make0_score

#make the number 3
make3_score:
lw $t0, displayAddress
addi $t0, $t0, 8
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
j after_numbers_score

#make the number 2
make2_score:
lw $t0, displayAddress
addi $t0, $t0, 8
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)

j after_numbers_score

#make the number 1
make1_score:
lw $t0, displayAddress
addi $t0, $t0, 16
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)

j after_numbers_score


#make the number 0
make0_score:
lw $t0, displayAddress
addi $t0, $t0, 8
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 8
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 8
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 8
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)

after_numbers_score:




#check if the goal should be filled
li $t7, 1
lw $t8, goal1($zero)

beq $t8, $t7, fill_goal1
j not_fill

fill_goal1:
#CREATE Yellow square to fill in goal
lw $t0, displayAddress   #bring t0 back to 0
addi $t0, $t0, 160
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0xffff00 #change t1 to yellow

jal square

j after_first_goal


not_fill:

#CREATE FIRST GOAL
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, 160
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0x0276ab #change t1 to blue

jal square

after_first_goal:


#check if second goal should be filled
li $t7, 1
lw $t8, goal2($zero)
beq $t8, $t7, fill_goal2
j not_fill2


fill_goal2:
#CREATE Yellow square to fill in goal
lw $t0, displayAddress  #bring t0 back to 0
addi $t0, $t0, 192
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0xffff00 #change t1 to yellow

jal square

j after_second_goal

not_fill2:

#CREATE SECOND GOAL
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, 192
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0x0276ab #change t1 to blue


jal square


after_second_goal:


#check if second goal should be filled
li $t7, 1
lw $t8, goal3($zero)
beq $t8, $t7, fill_goal3
j not_fill3


fill_goal3:
#CREATE Yellow square to fill in goal
lw $t0, displayAddress  #bring t0 back to 0
addi $t0, $t0, 224
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0xffff00 #change t1 to yellow

jal square

j after_third_goal

not_fill3:

#CREATE THIRD GOAL
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, 224
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0x0276ab #change t1 to blue


jal square

after_third_goal:


bne $s7, $zero, fill_wrap #check if its after 1st iteration 


#start making the log river
#start loading the array with brown
li $t0, 0
li $t8, 1
li $t7, 33
li $t5, 0x964B00

jal array_filler

#load into array with blue
li $t0, 32
li $t8, 1
li $t7, 33
li $t5, 0x0000FF

jal array_filler

#load into array with brown
li $t0, 64
li $t8, 1
li $t7, 33
li $t5, 0x964B00

jal array_filler

#load into array with blue
li $t0, 96
li $t8, 1
li $t7, 33
li $t5, 0x0000FF

jal array_filler


j after_wrap


fill_wrap:

#we first load logs2 with the first 127 items of logs
li $t8, 1
li $t9, 128
li $t7, 0
transfer:
lw $s5, logs($t7)
sw $s5, logstore($t7)


addi $t7, $t7, 4
addi $t8, $t8, 1
beq $t8, $t9, after_transfer
j transfer

after_transfer:

#then, we store the last element in logs in  a register
li $t8, 508
lw $s7, logs($t8)


#next, we put the 127 items of logs back into logs starting from its 2nd index
li $t8, 1
li $t9, 128
li $t7, 0
li $t1, 4

transfer2:
lw $s5, logstore($t7)
sw $s5, logs($t1)


addi $t7, $t7, 4
addi $t1, $t1, 4
addi $t8, $t8, 1
beq $t8, $t9, after_transfer2
j transfer2

after_transfer2:


#we then make the last element from logs previously the first element in logs this time
sw $s7, logs($zero)


after_wrap:


#paint top row of river
li $t8, 0
li $t7, 128
li $s4, 0
lw $t0, displayAddress
addi $t0, $t0, 640

fill_row:

lw $s5, logs($s4)
sw $s5, 0($t0)

addi $t0, $t0, 4
addi $s4, $s4, 4

addi $t8, $t8, 1
beq $t8, $t7, after_filler
j fill_row


after_filler:

li $s7, 1   #change s7 to 1 so now it gets updated, the log row


#PAINT THE RIVER

lw $t0, displayAddress
addi $t0, $t0, 1152
li $t8, 0
li $t7, 128
li $t1, 0x0000FF #set to blue

jal paintgreen #call to make the water


li $t5, 0x964B00

li $t8, 1148
addi $t7, $s6, -28
beq $t8, $t7, seven

addi $t7, $s6, -24
beq $t8, $t7, six

addi $t7, $s6, -20
beq $t8, $t7, five

addi $t7, $s6, -16
beq $t8, $t7, four

addi $t7, $s6, -12
beq $t8, $t7, three_log

addi $t7, $s6, -8
beq $t8, $t7, two_log

addi $t7, $s6, -4
beq $t8, $t7, one_log

j normal_log


#it its seven
seven:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 5
li $t8, 1
li $t9, 1
li $t1, 128

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 29
li $t8, 1
li $t9, 7
li $t1, 152

jal reverse_log
j after

#it is six
six:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 9
li $t8, 1
li $t9, 2
li $t1, 132

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 25
li $t8, 1
li $t9, 6
li $t1, 148

jal reverse_log
j after


#it is five
five:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 13
li $t8, 1
li $t9, 3
li $t1, 136

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 21
li $t8, 1
li $t9, 5
li $t1, 144

jal reverse_log
j after

#it is four
four:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 17
li $t8, 1
li $t9, 4
li $t1, 140

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 17
li $t8, 1
li $t9, 4
li $t1, 140

jal reverse_log

j after


#it is three
three_log:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 21
li $t8, 1
li $t9, 5
li $t1, 144

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 13
li $t8, 1
li $t9, 3
li $t1, 136

jal reverse_log

j after

#it is two
two_log:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 25
li $t8, 1
li $t9, 6
li $t1, 148

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 9
li $t8, 1
li $t9, 2
li $t1, 132

jal reverse_log

j after

#it is one
one_log:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 29
li $t8, 1
li $t9, 7
li $t1, 152

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 5
li $t8, 1
li $t9, 1
li $t1, 128

jal reverse_log

j after


#normal log, dont make it wrap 
normal_log:

lw $t0, displayAddress
add $t0, $t0, $s6
li $t7, 33
li $t8, 1
li $t9, 8
li $t1, 156

jal reverse_log

after:


li $t8, 1148
addi $t7, $v1, -28
beq $t8, $t7, seven_log2

addi $t7, $v1, -24
beq $t8, $t7, six_log2

addi $t7, $v1, -20
beq $t8, $t7, five_log2

addi $t7, $v1, -16
beq $t8, $t7, four_log2

addi $t7, $v1, -12
beq $t8, $t7, three_log2

addi $t7, $v1, -8
beq $t8, $t7, two_log2

addi $t7, $v1, -4
beq $t8, $t7, one_log2

j normal_log2

#it its seven
seven_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 5
li $t8, 1
li $t9, 1
li $t1, 128

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 29
li $t8, 1
li $t9, 7
li $t1, 152

jal reverse_log
j after2log

#it is six
six_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 9
li $t8, 1
li $t9, 2
li $t1, 132

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 25
li $t8, 1
li $t9, 6
li $t1, 148

jal reverse_log
j after2log


#it is five
five_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 13
li $t8, 1
li $t9, 3
li $t1, 136

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 21
li $t8, 1
li $t9, 5
li $t1, 144

jal reverse_log
j after2log

#it is four
four_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 17
li $t8, 1
li $t9, 4
li $t1, 140

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 17
li $t8, 1
li $t9, 4
li $t1, 140

jal reverse_log

j after2log


#it is three
three_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 21
li $t8, 1
li $t9, 5
li $t1, 144

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 13
li $t8, 1
li $t9, 3
li $t1, 136

jal reverse_log

j after2log

#it is two
two_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 25
li $t8, 1
li $t9, 6
li $t1, 148

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 9
li $t8, 1
li $t9, 2
li $t1, 132

jal reverse_log

j after2log

#it is one
one_log2:
lw $t0, displayAddress
addi $t0, $t0, 1276
li $t7, 29
li $t8, 1
li $t9, 7
li $t1, 152

jal reverse_log

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 5
li $t8, 1
li $t9, 1
li $t1, 128

jal reverse_log

j after2log


#normal log, dont make it wrap 
normal_log2:

lw $t0, displayAddress
add $t0, $t0, $v1
li $t7, 33
li $t8, 1
li $t9, 8
li $t1, 156

jal reverse_log

after2log:


#update the log position
li $t8, 1152
beq $s6, $t8, next_log
j normal_increment

next_log:
li $s6, 1280 #set the position back at the end

normal_increment: #normal increment
addi $s6, $s6, -4


#update the second log position
li $t8, 1152
beq $v1, $t8, next_log2
j normal_increment2

next_log2:
li $v1, 1280 #set the position back at the end

normal_increment2: #normal increment
addi $v1, $v1, -4





#initialize the loop variables t8 and t7, paints the middle grass
lw $t0, displayAddress
addi $t0, $t0, 1664
li $t8, 0 #initially set t8 to 0
li $t7, 128 #set t7 to 160
li $t1, 0x00ff00  #change t1 back to green

#call to the function to make the grass
jal paintgreen


#start painting the roads and cars
#set loop conditions for the road
lw $t0, displayAddress
addi $t0, $t0, 2176
li $t8, 0
li $t7, 256 #make t7 now 256 again, the road will be 8 rows long
li $t1, 0x000000 #change the colour of t1 to black

#call function painblack to paint the road
jal paintgreen


#set conditions for the starting green zone
lw $t0, displayAddress
addi $t0, $t0, 3200
li $t8, 0
li $t7, 224
li $t1, 0x00ff00  #change t1 back to green

#call paintgreen again to pain the grass
jal paintgreen


#THIS IS THE LIVES DISPLAY
lw $t8, lives($zero)
#display number of lives
#we first check what values are stored inside the registers of k
beq $t8, 3, make3

beq $t8, 2, make2

beq $t8, 1, make1

#make the number 3
make3:
lw $t0, displayAddress
addi $t0, $t0, 3336
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)


lw $t0, displayAddress
addi $t0, $t0, 3608
jal draw_x


j after_numbers

#make the number 2
make2:
lw $t0, displayAddress
addi $t0, $t0, 3336
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)

lw $t0, displayAddress
addi $t0, $t0, 3608
jal draw_x

j after_numbers

#make the number 1
make1:
lw $t0, displayAddress
addi $t0, $t0, 3344
li $t1, 0x000000
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)

lw $t0, displayAddress
addi $t0, $t0, 3608
jal draw_x

after_numbers:



#PAINT THE CARS
#paint the 4th car
li $t7, 0
addi $t7, $s3, 12
li $t8, 2816
beq $t7, $t8, three

li $t7, 0
addi $t7, $s3, 8
beq $t7, $t8, two

li $t7, 0
addi $t7, $s3, 4
beq $t7, $t8, one
j normal_create

three:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s3
li $t8, 1
li $t7, 13
li $t5, 0xff0000
li $t1, 120

jal car_3
j after1

two:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s3
li $t8, 1
li $t7, 9
li $t5, 0xff0000
li $t1, 124

jal car_2
j after1

one:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s3
li $t8, 1
li $t7, 5
li $t5, 0xff0000

jal car_1
j after1


normal_create:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s3
li $t8, 1
li $t7, 17
li $t1, 0xff0000

jal square

after1:






#paint car 3
li $t7, 0
addi $t7, $s2, 12
li $t8, 2816
beq $t7, $t8, three2

li $t7, 0
addi $t7, $s2, 8
beq $t7, $t8, two2

li $t7, 0
addi $t7, $s2, 4
beq $t7, $t8, one2
j normal_create2


three2:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s2
li $t8, 1
li $t7, 13
li $t5, 0xff0000
li $t1, 120

jal car_3
j after2

two2:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s2
li $t8, 1
li $t7, 9
li $t5, 0xff0000
li $t1, 124

jal car_2
j after2

one2:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s2
li $t8, 1
li $t7, 5
li $t5, 0xff0000

jal car_1
j after2


normal_create2:

lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s2
li $t8, 1
li $t7, 17
li $t1, 0xff0000

jal square

after2:


#paint car 2
addi $t7, $s1, -12
li $t8, 2172
beq $t7, $t8, three3


addi $t7, $s1, -8
beq $t7, $t8, two3


addi $t7, $s1, -4
beq $t7, $t8, one3
j normal_create3


three3:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s1
li $t8, 1
li $t7, 13
li $t5, 0xff0000
li $t1, 120

jal reverse_car_3
j after3

two3:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s1
li $t8, 1
li $t7, 9
li $t5, 0xff0000
li $t1, 124

jal reverse_car_2
j after3

one3:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s1
li $t8, 1
li $t7, 5
li $t5, 0xff0000

jal reverse_car_1
j after3


normal_create3:

lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s1
li $t8, 1
li $t7, 17
li $t1, 0xff0000

jal reverse_square

after3:


#paint car 1
addi $t7, $s0, -12
li $t8, 2172
beq $t7, $t8, three4


addi $t7, $s0, -8
beq $t7, $t8, two4


addi $t7, $s0, -4
beq $t7, $t8, one4
j normal_create4


three4:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s0
li $t8, 1
li $t7, 13
li $t5, 0xff0000
li $t1, 120

jal reverse_car_3
j after4

two4:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s0
li $t8, 1
li $t7, 9
li $t5, 0xff0000
li $t1, 124

jal reverse_car_2
j after4

one4:
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s0
li $t8, 1
li $t7, 5
li $t5, 0xff0000

jal reverse_car_1
j after4



normal_create4:

lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $s0
li $t8, 1
li $t7, 17
li $t1, 0xff0000

jal reverse_square

after4:

#update location of the car 4
li $t8, 2816
addi $t7, $s3, 4
beq $t7, $t8, wrap
j normal


wrap:
li $s3, 2688
j next

normal:
addi $s3, $s3, 4

next:

#update location of car3
li $t8, 2816
addi $t7, $s2, 4
beq $t7, $t8, wrap2
j normal2

wrap2:
li $s2, 2688
j next2

normal2:
addi $s2, $s2, 4

next2:

#update location of car2
li $t8, 2172
addi $t7, $s1, -4
beq $t8, $t7, wrap3
j normal3

wrap3:
li $s1, 2300
j next3

normal3:
addi $s1, $s1, -4

next3:

#update location of car1
li $t8, 2172
addi $t7, $s0, -4
beq $t8, $t7, wrap4
j normal4

wrap4:
li $s0, 2300
j next4

normal4:
addi $s0, $s0, -4

next4:

#record what values are going to be at the future corners of the frog

	#these are the positions of the frog before it gets drawn
	addi $t7, $a0, 12  # this gives us the top right corner of the frog
	addi $t6, $a0, 384 #gives the botton left corner of the frog
	addi $t5, $a0, 396 #gives the bottom right corner of the frog

	lw $t0, displayAddress
	add $t0, $t0, $a0
	lw $t9, 0($t0) #store the colour currently in that position
	
	lw $t0, displayAddress
	add $t0, $t0, $t7
	lw $t4, 0($t0)
	
	lw $t0, displayAddress
	add $t0, $t0, $t6
	lw $t6, 0($t0)
	
	lw $t0, displayAddress
	add $t0, $t0, $t5
	lw $t5, 0($t0)


#CREATE FROG
lw $t0, displayAddress   #bring t0 back to 0
add $t0, $t0, $a0
#create the yellow frog
li $t8, 1 #this creates the loop conditions for the frog (square), brings t8 to 1
li $t7, 17 #this brings t7 to 17
li $t1, 0xffff00 #change t1 to yellow

jal square

#draw eyes on the frog
#first load the value from frog_direction into t8
lw $t8, frog_direction($zero)

#check the values 
beq $t8, 0, draw_zero
beq $t8, 1, draw_one
beq $t8, 2, draw_two
beq $t8, 3, draw_three
beq $t8, 4, draw_four

draw_zero:
lw $t0, displayAddress
add $t0, $t0, $a0 #location of the left eye
li $t7, 0xFFFFFF #get white for the eyes
sw $t7, 0($t0)
addi $t0, $t0, 12 #location of the right eye
sw $t7, 0($t0)
j after_eyes

draw_one:
lw $t0, displayAddress
add $t0, $t0, $a0 #location of the top eye
li $t7, 0xFFFFFF #get white for the eyes
sw $t7, 0($t0)
addi $t0, $t0, 384 #location of the bottom eye
sw $t7, 0($t0)
j after_eyes

draw_two:
lw $t0, displayAddress
add $t0, $t0, $a0 #location of the left eye
li $t7, 0xFFFFFF #get white for the eyes
sw $t7, 0($t0)
addi $t0, $t0, 12 #location of the right eye
sw $t7, 0($t0)
j after_eyes

draw_three:
lw $t0, displayAddress
add $t0, $t0, $a0 
addi $t0, $t0, 384 #location of the bottom left eye
li $t7, 0xFFFFFF #get white for the eyes
sw $t7, 0($t0)
addi $t0, $t0, 12 #location of the bottom right eye
sw $t7, 0($t0)
j after_eyes

draw_four:
lw $t0, displayAddress
add $t0, $t0, $a0 
addi $t0, $t0, 12 #location of the rop right eye
li $t7, 0xFFFFFF #get white for the eyes
sw $t7, 0($t0)
addi $t0, $t0, 384 #location of the bottom right eye
sw $t7, 0($t0)
j after_eyes

after_eyes:


#detect collision here

#top left corner
beq $t9, 0xff0000, restart
beq $t9, 0x0000ff, restart

#top right corner
beq $t4, 0xff0000, restart
beq $t4, 0x0000ff, restart


#bottom left corner
beq $t6, 0xff0000, restart
beq $t6, 0x0000ff, restart

#bottom right corner
beq $t5, 0xff0000, restart
beq $t5, 0x0000ff, restart

j no_collision

restart: #if frog hits car or hits water, it dies and restarts at starting location
#death animation
lw $t0, displayAddress
add $t0, $t0, $a0
addi $t0, $t0, -4
jal death
li $v0, 32
li $a0, 500
syscall

#decreases the lives
lw $t8, lives($zero)
addi $t8, $t8, -1
sw $t8, lives($zero)
beq $t8, $zero, retry_loop
lw $t2, frog_x 
lw $t3, frog_y 

#creates the sound of death
#we want the sound to become 2
li $t8, 2
sw $t8, sound($zero)

no_collision:

li $t7, 160
beq $a0, $t7, first_goal

li $t7, 192
beq $a0, $t7, second_goal

li $t7, 224
beq $a0, $t7, third_goal

j after_goal #if frog not reached any of the goals, skip all, START WITH JUST THE FIRST GOAL

#first goal reached
first_goal:

#bring frog back to original location
lw $t2, frog_x 
lw $t3, frog_y 

#check if goal1 already filled
lw $t8, goal1($zero)
beq $t8, 1, dont_fill1

#make it 1
li $a1, 1
sw $a1, goal1($zero)

#we want to increment the number of goals filled
lw $t8, num_goals($zero)
addi $t8, $t8, 1
sw $t8, num_goals($zero)

dont_fill1:

#we want the sound to become 3
li $t8, 3
sw $t8, sound($zero)

j after_goal

#second goal reached
second_goal:

lw $t2, frog_x 
lw $t3, frog_y 

#check if goal2 already filled
lw $t8, goal2($zero)
beq $t8, 1, dont_fill2

li $a2, 1
sw $a2, goal2($zero)

#we want to increment the number of goals filled
lw $t8, num_goals($zero)
addi $t8, $t8, 1
sw $t8, num_goals($zero)

dont_fill2:

#we want the sound to become 3
li $t8, 3
sw $t8, sound($zero)


j after_goal

#third goal reached
third_goal:

lw $t2, frog_x 
lw $t3, frog_y 

#check if goal3 already filled
lw $t8, goal3($zero)
beq $t8, 1, dont_fill3

li $t6, 1
sw $t6, goal3($zero)

#we want to increment the number of goals filled
lw $t8, num_goals($zero)
addi $t8, $t8, 1
sw $t8, num_goals($zero)

dont_fill3:

#we want the sound to become 3
li $t8, 3
sw $t8, sound($zero)


after_goal:

#CREATE THE SOUND HERE
lw $t8, sound($zero)
beq $t8, 1, jump_sound
beq $t8, 2, death_sound
beq $t8, 3, goal_sound
j sound_over

jump_sound:
li $v0, 31
li $a0, 100
li $a1, 100
li $a2, 0
li $a3, 50
syscall
j sound_over

death_sound:
#we will have 2 sounds here, one for collision and one for death
li $v0, 31
li $a0, 80
li $a1, 100
li $a2, 2
li $a3, 50
syscall

#pause for a bit
li $v0, 32
li $a0, 500
syscall


li $v0, 31
li $a0, 50
li $a1, 500
li $a2, 2
li $a3, 50
syscall
j sound_over

goal_sound:
li $v0, 31
li $a0, 110
li $a1, 200
li $a2, 0
li $a3, 50
syscall


sound_over:

#once all goals are filled, go to retry menu
li $t8, 3
lw $t7, num_goals($zero)
beq $t8, $t7, retry_loop

lw $t0, displayAddress #set t0 back to 0

li $v0, 32
li $a0, 100
syscall

j main


#once all lives run out, go into this loop and detect keyboard input to restart the game
retry_loop:
#start detecting keyboard input
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input2
j after_key2


#check which letter was pressed
keyboard_input2:
lw $t8, 0xffff0004
beq $t8, 0x72, respond_to_R
beq $t8, 0x71, Exit  #if q is pressed, exit the program

j after_key2 #if neither W, A, S, D were pressed, skip to after_key label

respond_to_R:
j game #once R is pressed, return back to the main loop (aka the game)

after_key2:

li $t7, 1
li $t8, 1024
lw $t0, displayAddress
li $t1, 0x00ff00
paint_the_screen:
sw $t1, 0($t0)

addi $t0, $t0, 4
addi $t7, $t7, 1
beq $t7, $t8, exit_loop
j paint_the_screen

exit_loop:

lw $t0, displayAddress
addi $t0, $t0, 520
li $t1, 0xffff00

#this spells the words on the retry screen, starting with r
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)

lw $t0, displayAddress
addi $t0, $t0, 544
#second r
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)

#first e
lw $t0, displayAddress
addi $t0, $t0, 560
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 8
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)

#first t
lw $t0, displayAddress
addi $t0, $t0, 576
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, -136
sw $t1, 0($t0)
addi $t0, $t0, -128
sw $t1, 0($t0)
addi $t0, $t0, 384
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)


#third r
lw $t0, displayAddress
addi $t0, $t0, 600
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 120
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)

#makes the y
lw $t0, displayAddress
addi $t0, $t0, 616
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, -128
sw $t1, 0($t0)
addi $t0, $t0, -128
sw $t1, 0($t0)
addi $t0, $t0, -128
sw $t1, 0($t0)
addi $t0, $t0, -128
sw $t1, 0($t0)
addi $t0, $t0, 640
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)


li $v0, 32
li $a0, 2000
syscall

j retry_loop


#loop to pause
pause_loop:
#start detecting keyboard input
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input_pause
j no_pause

keyboard_input_pause:
lw $t8, 0xffff0004
beq $t8, 0x70, respond_to_P2
j no_pause

respond_to_P2:
j after_key #if neither W, A, S, D were pressed, skip to after_key label

no_pause:

#draw the pause symbol
lw $t0, displayAddress
addi $t0, $t0, 1728
li $t8, 0x000000
sw $t8, 0($t0)
addi $t0, $t0, 128
sw $t8, 0($t0)
addi $t0, $t0, 128
sw $t8, 0($t0)
lw $t0, displayAddress
addi $t0, $t0, 1736
sw $t8, 0($t0)
addi $t0, $t0, 128
sw $t8, 0($t0)
addi $t0, $t0, 128
sw $t8, 0($t0)

j pause_loop



#FUNCTIONS
paintgreen:
beq $t8, $t7, end_rect #branch to check if t8 is equal to 160 or not, go to changeblue once the loop over

sw $t1, 0($t0) #paint the current pixel
addi $t0, $t0, 4 #go to next pixel

addi $t8, $t8, 1 #increment t8 by 1

j paintgreen

end_rect:
jr $ra


#creates a square
square:     
beq $zero, $t8, ifzero

li $t9, 4
div $t8, $t9
mfhi $t9

beq $t9, $zero, divisibleby4 #checks if the value is divisible or not by 4

ifzero:
sw $t1, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_s
j square

divisibleby4:
sw $t1, 0($t0)
addi $t0, $t0, 116
addi $t8, $t8, 1
beq $t7, $t8, end_s
j square

sw $t1, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_s #once both t7 and t8 are equal, create the vehicles

j square

end_s:
jr $ra



#making 3 wide car
car_3:
beq $zero, $t8, ifzerocar3

li $t9, 3
div $t8, $t9
mfhi $t9

beq $t9, $zero, divisibleby3car3 #checks if the value is divisible or not by 4

ifzerocar3:
sw $t5, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_c3
j car_3

divisibleby3car3:
sw $t5, 0($t0)
addi $t0, $t0, 120
addi $t8, $t8, 1
beq $t7, $t8, end_c3
j car_3

sw $t5, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_c3 #once both t7 and t8 are equal, create the vehicles

j car_3

end_c3:
jr $ra


#making 3 wide car
car_2:
beq $zero, $t8, ifzerocar2

li $t9, 2
div $t8, $t9
mfhi $t9

beq $t9, $zero, divisibleby2car2 #checks if the value is divisible or not by 4

ifzerocar2:
sw $t5, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_c2
j car_2

divisibleby2car2:
sw $t5, 0($t0)
addi $t0, $t0, 124
addi $t8, $t8, 1
beq $t7, $t8, end_c2
j car_2

sw $t5, 0($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_c2 #once both t7 and t8 are equal, create the vehicles

j car_2

end_c2:
jr $ra


#for making a line
car_1:     
sw $t5, 0($t0)

add $t0, $t0, 128
addi $t8, $t8, 1
beq $t7, $t8, end_c1
j car_1

end_c1:
jr $ra


#creates a square in reverse
reverse_square:     
beq $zero, $t8, reverseifzero

li $t9, 4
div $t8, $t9
mfhi $t9

beq $t9, $zero, reversedivisibleby4 #checks if the value is divisible or not by 4

reverseifzero:
sw $t1, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end
j reverse_square

reversedivisibleby4:
sw $t1, 0($t0)
addi $t0, $t0, 140
addi $t8, $t8, 1
beq $t7, $t8, reverse_end
j reverse_square

sw $t1, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end #once both t7 and t8 are equal, create the vehicles

j reverse_square

reverse_end:
jr $ra




#making 3 wide reverse car
reverse_car_3:
beq $zero, $t8, reversezerocar3

li $t9, 3
div $t8, $t9
mfhi $t9

beq $t9, $zero, reversedivisibleby3car3 #checks if the value is divisible or not by 4

reversezerocar3:
sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c3
j reverse_car_3

reversedivisibleby3car3:
sw $t5, 0($t0)
addi $t0, $t0, 136
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c3
j reverse_car_3

sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c3 #once both t7 and t8 are equal, create the vehicles

j reverse_car_3

reverse_end_c3:
jr $ra



#making 2 wide reverse car
reverse_car_2:
beq $zero, $t8, reversezerocar2

li $t9, 2
div $t8, $t9
mfhi $t9

beq $t9, $zero, reversedivisibleby2car2 #checks if the value is divisible or not by 4

reversezerocar2:
sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c2
j reverse_car_2

reversedivisibleby2car2:
sw $t5, 0($t0)
addi $t0, $t0, 132
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c2
j reverse_car_2

sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c2 #once both t7 and t8 are equal, create the vehicles

j reverse_car_2

reverse_end_c2:
jr $ra

#for making a line
reverse_car_1:     
sw $t5, 0($t0)

add $t0, $t0, 128
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_c1
j reverse_car_1

reverse_end_c1:
jr $ra




#loop to fill in the array
array_filler:
beq $zero, $t8, filler_zero

li $t9, 8
div $t8, $t9
mfhi $t9

beq $t9, $zero, filler_divisible #checks if the value is divisible or not by 4

filler_zero:
sw $t5, logs($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_filler
j array_filler

filler_divisible:
sw $t5, logs($t0)
addi $t0, $t0, 100
addi $t8, $t8, 1
beq $t7, $t8, end_filler
j array_filler

sw $t5, logs($t0)
addi $t0, $t0, 4
addi $t8, $t8, 1
beq $t7, $t8, end_filler #once both t7 and t8 are equal, create the vehicles

j array_filler

end_filler:
jr $ra



#makes a log in reverse
reverse_log:     
beq $zero, $t8, reverseifzero_log


div $t8, $t9  #t9 can be 1, 2, 3, 4, 5, 6, 7, the length of a row
mfhi $t6

beq $t6, $zero, reversedivisibleby_log #checks if the value is divisible or not by 4

reverseifzero_log:
sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_log
j reverse_log

reversedivisibleby_log:
sw $t5, 0($t0)
add $t0, $t0, $t1  # how much we adjust to get to next row
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_log
j reverse_log

sw $t5, 0($t0)
addi $t0, $t0, -4
addi $t8, $t8, 1
beq $t7, $t8, reverse_end_log #once both t7 and t8 are equal, create the vehicles

j reverse_log

reverse_end_log:
jr $ra


#this function draws an x
draw_x:
li $t1, 0x000000
sw $t1, 0($t0)

addi $t0, $t0, 8
sw $t1, 0($t0)

addi $t0, $t0, 124
sw $t1, 0($t0)

addi $t0, $t0, 124
sw $t1, 0($t0)

addi $t0, $t0, 8
sw $t1, 0($t0)

end_x:
jr $ra


#make skull and crossbones
death:
li $t1, 0xffffff
sw $t1, 0($t0)

addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 108
sw $t1, 0($t0)

li $t1, 0x000000
addi $t0, $t0, 4
sw $t1, 0($t0)

li $t1, 0xffffff
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)

li $t1, 0x000000
addi $t0, $t0, 4
sw $t1, 0($t0)

li $t1, 0xffffff
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 108
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 112
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)


end_death:
jr $ra



#exit the program
Exit:
li $v0, 10
syscall


