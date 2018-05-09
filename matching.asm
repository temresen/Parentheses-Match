###################
# Tahsin Emre Sen
###################


############################################
# Data Segment
# messages
############################################  
.data
input_msg1: .asciiz	"Enter the first string: "
input_str1: .space 48
newline: .asciiz "\n"
		
############################################
# Text Segment
# routines
############################################  
############################################
# Main Routine 		   	
############################################  
.text
main:
	la	$a0, input_msg1		# load the first input message
	jal	print_str		# print the input prompt
	
	la	$a0, input_str1		# load the space for the first string into register	
	addi	$a1, $zero, 48  	# the length of the string is 48
	jal	read_str		# read the input
	add	$s0, $a0, $zero		
	
	# TODO								
	add	$a0, $s0, $zero		# save second string address for compare
	jal	match	
	
	add	$a0, $v0, $zero		# prepare the cmp result for printing
	jal	print_int		# print it
	
	addi	$a0, $zero, '\n'	# print a newline
	j	exit			# exit
	
exit:
	addi	$v0, $zero, 10		# system code for exit
	syscall				# exit gracefully

############################################
# I/O Routines
############################################
print_str:				# $a0 has string to be printed
	addi	$v0, $zero, 4		# system code for print_str
	syscall				# print it
	jr 	$ra			# return
	
	
print_int:				# $a0 has number to be printed
	addi	$v0, $zero, 1		# system code for print_int
	syscall
	jr 	$ra
	

read_str:				# address of str in $a0, 	
					# length is in $a1.
	addi	$v0, $zero, 8		# system code for read_str
	syscall
	jr 	$ra	
##############################################
# match Routine	   
# $a0: memory address of the str1. 
# $v0:-1 if the str1 contains unknown characters and if it is unbalanced, 
#     1  if it is balanced  
##############################################  	
match:
	# a0 memory address of the str	
						
	addi $t8 , $zero, 0 # t8 will store number of '('
	addi $t9 , $zero, 0 # t9 will store number of ')'
	
	while: #while we have a string to read	
		lb $t1, 0($a0) #load the string which is shown by address(a0) into t1
		#we will do our comparision with this string which is in t1 now.
		beq $t1, '(', increasefirst # if t1 equals to '(' jump to increasefirst
		beq $t1, ')', increasesecond # if t1 equals to ')' jump to increasesecond
		
		
			    #if none of the conditions are set 
		j lastcheck #jump to lastcheck which will compare the number of '(' and the number of ')'
		
		jr $ra
		
	increasefirst:
		addi $t8, $t8, 1 #increase t8(number of '('  ) by 1
		addi $a0, $a0, 1 # Increasing the address of a0 by 1 byte
		j while
	increasesecond:
		addi $t9, $t9, 1 #increase t9(number of ')'  ) by 1
		addi $a0, $a0, 1 # Increasing the address of a0 by 1 byte
		j while
	lastcheck:
		beq $t8 , $t9, true #If number of '(' equals to number of ')' jump true
		addi $v0, $zero, -1 #false >> set our return value -1
		jr $ra 
	true:
		addi $v0, $zero, 1 #true >> set our return value 1
		jr $ra 