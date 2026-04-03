.section .rodata

print_fmt: 
.string "%lld "

print_newline: 
.string "\n"

.globl main

main: 

#initilize stack

addi sp,sp,-64
sd ra,56(sp) 
sd s0,48(sp) 
sd s1,40(sp) 
sd s2,32(sp)
sd s3,24(sp)
sd s4,16(sp)
sd s5,8(sp)
sd s6,0(sp)

mv s0,a0 # s0 = a0 (default argc)
mv s1,a1 # s1 = a1 (default argv)

# allocate array for storing

addi a0,s0,-1 # s0 = n + 1. a0 = n
slli a0,a0,3 # a0 = n * 8 
call malloc
mv s2,a0 #s2 = address of IQ array

# allocate results array

addi a0,s0,-1 
slli a0,a0,3 
call malloc
mv s3,a0 #s3 = address of result array

# allocate stack

addi a0,s0,-1 
slli a0,a0,3 
call malloc
mv s4,a0 #s4 = address of stack
li s5,-1 #s5 = top of stack

# put values into IQ array

li t0,1 # i = 1 as i = 0 as program name

place_into_iq: 

bge t0,s0,done 

slli t1,t0,3 # t1 = i * 8 bytes
add t2,t1,s1 # t2 = s1 + t1 
ld a0,0(t2) # get string from argv[i]

call atoll # convert to long long int

addi t3,t0,-1 # t3 = i - 1
slli t3,t3,3 # t3 = t3 * 8 bytes
add t4,s2,t3 # t4 = s2 + t3
sd a0,0(t4)

addi t0,t0,1
j place_into_iq

done:
# completed 

addi s0,s0,-1 # s0 = argc - 1 = no. of students (n) 
addi t0,s0,-1 # t0 = n - 1

outer_loop:

bltz t0,outer_loop_end # i < 0 then done

inner_loop: 

li t1,-1 # t1 = constant -1
beq s5,t1,inner_loop_end # if stack_top = -1 exit inner loop

slli t2,s5,3 # t2 = stack_top * 8 bytes
add t3,s4,t2 # t3 = s4 + t2 
ld t4,0(t3) # t4 = stack[top] <>

slli t5,t4,3 # t5 = t4 * 8 bytes
add t6, t5, s2 # t6 = address of IQ[stack[top]]
ld t2, 0(t6) # t2 = IQ[stack[top]] <>

slli t3,t0,3 # t3 = i * 8
add t3,s2,t3 # t3 = IQ + i * 8 
ld t3, 0(t3) # t3 = IQ[i] <>

bgt t2,t3,inner_loop_end

addi s5,s5,-1
j inner_loop

inner_loop_end:

li t1,-1
beq s5,t1,minus_1

slli t6,t0,3 # t6 = i * 8
add t6,s3,t6 # t6 = result + i * 8
sd t4,0(t6) # result[i] = stack[top]

j push_into_stack

minus_1:

li t1,-1  # t1 = -1
slli t6,t0,3 # t6 = i * 8
add t6,s3,t6 # t6 = result + i * 8
sd t1,0(t6) # result[i] = -1

push_into_stack:

addi s5,s5,1 # top++
slli t6,s5,3 # t6 = top * 8
add t6,s4,t6 # t6 = stack + top*8
sd t0,0(t6)

addi t0,t0,-1
j outer_loop

outer_loop_end:

li s6,0 # i = 0

print_loop:

bge s6,s0,end 

slli t0,s6,3 # t0 = i * 8 bytes
add t1,s3,t0  # t1 = results + i * 8
ld t2,0(t1) # t2 = results[i]

lla a0,print_fmt
mv a1,t2
call printf

addi s6,s6,1
j print_loop

end:

lla a0, print_newline
call printf

ld ra,56(sp)
ld s0,48(sp)
ld s1,40(sp)
ld s2,32(sp)
ld s3,24(sp)
ld s4,16(sp)
ld s5,8(sp)
ld s6,0(sp)
addi sp,sp,64

li a0,0
ret 