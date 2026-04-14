.section .rodata

filename: 
.string "input.txt"

mode: 
.string "r"

yes_string:
.string "Yes\n"

no_string:
.string "No\n"

.section .text
.globl main

main:

addi sp,sp,-48
sd ra,40(sp)
sd s0,32(sp)
sd s1,24(sp)
sd s2,16(sp)
sd s3,8(sp)
sd s4,0(sp)

# opening the file

la a0,filename
la a1,mode
call fopen
mv s0,a0 # s0 = file pointer

# move pointer to end - fseek(fp,offset,origin)

mv a0,s0 # a0 = fp
li a1,0 # a1 = offset = 0
li a2,2 # a2 = origin = 2 ( end ) 
call fseek

# count no. of letters n

mv a0,s0 # a0 = fp
call ftell
mv s1,a0 # a1 = length n

beqz s1, is_palindrome # base case if string is empty

#set the left and right pointers i,j

li s2,0 # s2 = left
addi s3,s1,-1 # s3 = right

# the while loop : while ( i <= j ) 

loop:

bgt s2,s3,is_palindrome # if i > j done

# str[i] 

mv a0,s0 # a0 = fp 
mv a1,s2 # a1 = i (offset)
li a2,0 # a2 = 0 (origin)
call fseek

mv a0,s0
call fgetc # result in a0
mv s4,a0 #s4 = str[i] 

# str[j]

mv a0,s0
mv a1,s3 #a1 = j
li a2,0  #a2 = 0
call fseek

mv a0,s0
call fgetc 

bne s4,a0,is_not_palindrome # if str[i] != str[j] not palindrome

addi s2,s2,1 # i++
addi s3,s3,-1 # j--
j loop

is_palindrome:

lla a0,yes_string
call printf
j end

is_not_palindrome:

lla a0,no_string
call printf

end:

# close file

mv a0,s0
call fclose

# restore stack values

ld ra,40(sp)
ld s0,32(sp)
ld s1,24(sp)
ld s2,16(sp)
ld s3,8(sp)
ld s4,0(sp)
addi sp,sp,48

ret
