#Code encrypts and decrypts the string in the same run to display functionality.
	.data

encrypted:	.space	200
plain:		.space 	200
input: 	.asciiz		"WINNIE THE POOH."
onepad: .asciiz		"IDIDKNOWONCEONLYIVESORTOFFORGOTTEN."


	.globl		main
	.text
	
main:	la $a0, input
	la $a1, onepad
	la $a2, encrypted
	
	jal encrypt
		
	move $a0, $v0			#move output of encrypt into input of decrypt
	la $a2, plain			#load output of decrypt with plaintext array
	jal decrypt
	
	j testenc			#loop to test output	
end:	li $v0, 10
	syscall
	
encrypt:move $t0, $a0
	move $t1, $a1
	move $t2, $a2
enloop:	lb $s0, 0($t0)
check:	blt $s0, 65, Punc		#if character is punctuation continue on to next element, else proceed to regular calculation.
	bgt $s0, 90, Punc
	j calc
Punc:	beq $s0, 46, finish		#if full stop character; exit loop
	addi $t0, $t0, 1		#get next element of input string
	lb $s0, 0($t0)
	j check
	
finish:	sb $s0, 0($t2)
	la $v0, encrypted
	
	jr $ra

calc:	lb $s1, 0($t1)			#load letter it is to be encryted against
	add $s0, $s0, $s1		#add them together
	subi $s0, $s0, 128		#reduce this number to alphabet range (0-26)
	
	bgt $s0, 26, sub26		#if number is greater than 26, take 26 off of it
	j result
	
sub26:	subi $s0, $s0, 26

result:	addi $s0, $s0, 64		#put character back into ascii range (65 - 90)
	sb $s0, 0($t2)			#store in output as INTERGER FOR NOW
	
	addi $t0, $t0, 1		#iterating through input, onepad and out arrays
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	j enloop					
	
	
decrypt:move $t0, $a0			#encyrpted
	move $t1, $a1
	move $t2, $a2			#plaintext
deloop:	lb $s0, 0($t0)
	beq $s0, 46, fin		#if full stop character; add full stop to array and exit loop
	j notfin
	
fin:	sb $s0, 0($t2)
	la $v0, plain			#output plaintext string
	jr $ra
	
notfin:	lb $s1, 0($t1)			#load letter it is to be decryted against
	sub $s0, $s0, $s1		#subtract them
	blt $s0, 0, add26
	j cont
add26:	addi $s0, $s0, 26		#adds 26 if previous subtraction results in a negative value

cont:	addi $s0, $s0, 64		#places number in ascii range
	sb $s0, 0($t2)	
	
	addi $t0, $t0, 1		#iterating through input, onepad and out arrays
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	j deloop


testenc:li $v0, 4			#used to test the output of either subroutine
	la $t5, encrypted 		#prints to Run I/O screen
	add $a0, $t5, $zero
	syscall
	la $t5, plain
	add $a0, $t5, $zero
	syscall
	j end
