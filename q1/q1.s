.globl make_node;
.globl insert;
.globl get;
.globl getAtMost;

/*

STRUCT DEFINITION 

struct Node 
{
    int val;
    struct Node* left;
    struct Node* right;
};

*/

#1  struct Node* make_node(int val);

make_node:

# initialize stack
addi sp,sp,-16
sd ra,0(sp)
sd s0,8(sp)

mv s0,a0 # store int val into s0

li a0,24 # 24 bytes to allocate
call malloc

sw s0,0(a0) # 0 -> int val
sd x0,8(a0) # left = NULL
sd x0,16(a0) # right = NULL

# restore stack
ld ra,0(sp)
ld s0,8(sp)
addi sp,sp,16
ret

#3 struct Node* get(struct Node* root, int val); 

get: 

mv t0,a0 # t0 = curr = root 
mv t1,a1 # t1 = target value

find_loop:

beq t0,x0,not_found # if curr == NULL return NULL

lw t2,0(t0) # t2 = curr->val
beq t1,t2,found # if curr->val == target  return curr

blt t2,t1,right_side # if curr->val < target then go to right_side
ld t0,8(t0) # else curr = curr->left
j find_loop

right_side:

ld t0,16(t0) # curr = curr->right
j find_loop

found: 

mv a0,t0 # move curr into a0
ret

not_found:

li a0,0 # a0 = NULL
ret

#4 int getAtMost(int val, struct Node* root);

getAtMost:

mv t0,a0 # t0 = target value
mv t1,a1 # t1 = curr = root
li t2,-1 # t2 = result

greatest_loop:

beq t1,x0,done # if curr == NULL done

lw t3,0(t1) # t3 = curr->val

blt t3, t0, valid # if curr->val < target valid
beq t3,t0,match # else if curr->val == target done
ld t1,8(t1) # else curr = curr->left

j greatest_loop

valid:

mv t2,t3 # result = curr->val
ld t1,16(t1) # curr = curr->right ( search for larger value ) 
j greatest_loop

match:

mv a0,t0 # move target into a0
ret

done: 

mv a0,t2 # place result in a0
ret

#2 struct Node* insert(struct Node* root, int val); 

insert:

addi sp,sp,-48
sd ra,0(sp)
sd s0,8(sp)
sd s1,16(sp)
sd s2,24(sp)
sd s3,32(sp)

mv s0,a0 # s0 = root
mv s1,a1 # s1 = int val

beq s0,x0,empty_tree # if root == NULL empty_tree 

mv s2,s0 # s2 = root = curr

insert_loop:

lw t0,0(s2) # t0 = curr->val
beq s1,t0,put_root_to_return # if already exists return
# Assumption is that if there is already value in BST, nthg is done and just returns

mv s3,s2 # par = curr

blt s1,t0,go_to_left # if val < curr->val go_to_left 

ld s2,16(s3) # curr = curr-> right
bne s2,x0, insert_loop # if curr != NULL loop

/* else par->right = NULL so par->right to be inserted */

mv a0,s1 
call make_node
sd a0,16(s3)
j put_root_to_return

go_to_left:

ld s2,8(s3) # curr = curr-> left
bne s2,x0, insert_loop # if curr != NULL loop

/* else par->left == NULL so par->left to be inserted */
mv a0,s1 
call make_node
sd a0,8(s3)
j put_root_to_return

empty_tree:

mv a0,s1 # place int val in a0 to make_node
call make_node 
j exit

put_root_to_return:

mv a0,s0
j exit

exit:

ld ra,0(sp)
ld s0,8(sp)
ld s1,16(sp)
ld s2,24(sp)
ld s3,32(sp)
addi sp,sp,48
ret
