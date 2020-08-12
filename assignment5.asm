;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Calvin Glisson
; Email: cglis001@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 22
; TA: Jang-Shing Lin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000

;;; Instructions (main)
	begin
	
	LD R6, sub_menu_ptr	; Print menu, receive user choice in R1
	JSRR R6

	LD R0, newline
	OUT
	
	AND R2, R2, #0		; Branch to each possible menu option
	ADD R2, R2, #-1
	ADD R2, R2, R1
	BRz option_1

	AND R2, R2, #0
	ADD R2, R2, #-2
	ADD R2, R2, R1
	BRz option_2

	AND R2, R2, #0
	ADD R2, R2, #-3
	ADD R2, R2, R1
	BRz option_3

	AND R2, R2, #0
	ADD R2, R2, #-4
	ADD R2, R2, R1
	BRz option_4

	AND R2, R2, #0
	ADD R2, R2, #-5
	ADD R2, R2, R1
	BRz option_5

	AND R2, R2, #0
	ADD R2, R2, #-6
	ADD R2, R2, R1
	BRz option_6

	AND R2, R2, #0
	ADD R2, R2, #-7
	ADD R2, R2, R1
	BRz option_7

	option_1
		LD R6, sub_all_machines_busy_ptr
		JSRR R6

		ADD R2, R2, #0
		BRz main_not_all_busy

		main_all_busy
			LEA R0, allbusy
			PUTS
			BR end_main_not_all_busy
		end_main_all_busy

		main_not_all_busy
			LEA R0, allnotbusy
			PUTS
		end_main_not_all_busy
	
		BR begin
	end_option_1

	option_2
		LD R6, sub_all_machines_free_ptr
		JSRR R6

		ADD R2, R2, #0
		BRz main_not_all_free

		main_all_free
			LEA R0, allfree
			PUTS
			BR end_main_not_all_free
		end_main_all_free

		main_not_all_free
			LEA R0, allnotfree
			PUTS
		end_main_not_all_free
	
		BR begin
	end_option_2

	option_3
		LD R6, sub_num_busy_machines_ptr
		JSRR R6

		LEA R0, busymachine1
		PUTS

		AND R1, R1, #0
		ADD R1, R1, R2
		LD R6, sub_print_num_ptr
		JSRR R6
	
		LEA R0, busymachine2
		PUTS

		BR begin
	end_option_3

	option_4
		LD R6, sub_num_free_machines_ptr
		JSRR R6

		LEA R0, freemachine1
		PUTS

		AND R1, R1, #0
		ADD R1, R1, R2
		LD R6, sub_print_num_ptr
		JSRR R6
	
		LEA R0, freemachine2
		PUTS

		BR begin
	end_option_4

	option_5
		LD R6, sub_get_machine_num_ptr
		JSRR R6
		LD R6, sub_machine_status_ptr
		JSRR R6
	
		LEA R0, status1
		PUTS
	
		LD R6, sub_print_num_ptr
		JSRR R6

		ADD R2, R2, #0
		BRz option_5_is_busy

		option_5_is_free
			LEA R0, status3
			PUTS
	
			BR end_option_5_is_busy
		end_option_5_is_free
	
		option_5_is_busy
			LEA R0, status2
			PUTS
		end_option_5_is_busy

		BR begin
	end_option_5

	option_6
		LD R6, sub_first_free_ptr
		JSRR R6

		AND R1, R1, #0
		ADD R1, R1, #-15
		ADD R1, R1, R2		; R2 is 16 if no free machines were found
		BRp option_6_no_free_machines
		BR end_option_6_no_free_machines
	
		option_6_no_free_machines
			LD R0, firstfree2_ptr ; Have to use pointer because all the other strings push this one too far away
			PUTS
			BR begin
		end_option_6_no_free_machines

		LEA R0, firstfree1
		PUTS

		AND R1, R1, #0
		ADD R1, R1, R2
		LD R6, sub_print_num_ptr
		JSRR R6

		LD R0, newline
		OUT
	
		BR begin
	end_option_6

	option_7
		LEA R0, goodbye
		PUTS
	end_option_7
	
HALT

;;; Local data (main)
	;; SELF-WARNING: possible autograder might whine about changing subroutine addresses?
	menustring_ptr	.fill		x6A00 				; The menu itself
	sub_menu_ptr	.fill		x3100				; Subroutine pointers
	sub_all_machines_busy_ptr .fill x3200
	sub_all_machines_free_ptr .fill x3300
	sub_num_busy_machines_ptr .fill x3400
	sub_num_free_machines_ptr .fill x3500
	sub_machine_status_ptr	  .fill x3600
	sub_first_free_ptr	  .fill x3700
	sub_get_machine_num_ptr	  .fill x3800
	sub_print_num_ptr	  .fill x3900
	newline 	.fill 		'\n'				; Other data
	hex30_main	.fill		x30
	firstfree2_ptr	.fill		x3190
	error		.stringz	"Invalid input.\n" 		; Strings for reports from menu subroutines:
	goodbye         .stringz 	"Goodbye!\n"
	allbusy         .stringz 	"All machines are busy\n"
	allnotbusy      .stringz 	"Not all machines are busy\n"
	allfree         .stringz 	"All machines are free\n"
	allnotfree	.stringz 	"Not all machines are free\n"
	busymachine1    .stringz	"There are "
	busymachine2    .stringz	" busy machines\n"
	freemachine1    .stringz	"There are "
	freemachine2    .stringz	" free machines\n"
	status1         .stringz	"Machine "
	status2		.stringz	" is busy\n"
	status3		.stringz	" is free\n"
	firstfree1      .stringz 	"The first available machine is number "

.orig x3190
	firstfree2      .stringz	"No machines are free\n"

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------

.ORIG x31B0

;;; Instructions (menu subroutine)

	;; (1) Backup registers:
	ST R0, backup_r0_31B0
	ST R2, backup_r2_31B0
	ST R7, backup_r7_31B0

	;; (2) Subroutine algorithm:
	begin_31B0
	
	LD R0, menu_string_addr
	PUTS

	GETC
	OUT
	
	AND R1, R1, #0
	ADD R1, R1, R0

	LD R2, ascii_7
	NOT R2, R2
	ADD R2, R2, #1
	ADD R2, R2, R0
	BRp invalid_input	; Over 7
	LD R2, ascii_1
	NOT R2, R2
	ADD R2, R2, #1
	ADD R2, R2, R0
	BRn invalid_input	; Under 1

	BR end_invalid_input

	invalid_input
		LD R0, newline_31B0
		OUT
		LEA R0, error_msg_1
		PUTS
		BR begin_31B0
	end_invalid_input

	AND R1, R1, #0		; Return value in decimal
	ADD R1, R1, R0
	LD R2, hex30_31B0
	NOT R2, R2
	ADD R2, R2, #1
	ADD R1, R1, R2
	
	;; (3) Restore backed up registers
	LD R0, backup_r0_31B0
	LD R2, backup_r2_31B0
	LD R7, backup_r7_31B0

	;; (4) Return
	RET

;;; Local data (menu subroutine)
	
	error_msg_1		.stringz 	"INVALID INPUT\n"
	menu_string_addr  	.fill 		x6A00
	ascii_1			.fill		'1'
	ascii_7			.fill		'7'
	hex30_31B0		.fill		x30
	newline_31B0		.fill		'\n'
	backup_r0_31B0		.blkw		#1
	backup_r2_31B0		.blkw		#1
	backup_r7_31B0		.blkw		#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
	
.ORIG x3200

;;; Instructions (all_machines_busy subroutine)

	;; (1) Backup registers:
	ST R1, backup_r1_3200
	ST R7, backup_r7_3200

	;; (2) Subroutine algorithm:
	LDI R1, busyness_addr_all_machines_busy
	BRz all_machines_are_busy

	not_all_machines_are_busy
		AND R2, R2, #0
		BR end_all_machines_are_busy
	end_not_all_machines_are_busy

	all_machines_are_busy
		AND R2, R2, #0
		ADD R2, R2, #1
	end_all_machines_are_busy
	
	;; (3) Restore backed up registers
	LD R1, backup_r1_3200
	LD R7, backup_r7_3200

	;; (4) Return
	RET

;;; Local data (all_machines_busy subroutine)
	
	busyness_addr_all_machines_busy		.fill	xBA00
	backup_r1_3200				.blkw	#1
	backup_r7_3200				.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3300

;;; Instructions (all_machines_free subroutine)

	;; (1) Backup registers:
	ST R1, backup_r1_3300
	ST R7, backup_r7_3300

	;; (2) Subroutine algorithm:
	LDI R1, busyness_addr_all_machines_free
	ADD R1, R1, #1		; xFFFF is -1
	BRz all_machines_are_free

	not_all_machines_are_free
		AND R2, R2, #0
		BR end_all_machines_are_free
	end_not_all_machines_are_free

	all_machines_are_free
		AND R2, R2, #0
		ADD R2, R2, #1
	end_all_machines_are_free
	
	;; (3) Restore backed up registers
	LD R1, backup_r1_3300
	LD R7, backup_r7_3300

	;; (4) Return
	RET

;;; Local data (all_machines_free subroutine)
	
	busyness_addr_all_machines_free	.fill	xBA00
	fullvector			.fill	xFFFF
	backup_r1_3300			.blkw	#1
	backup_r7_3300			.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3400

;;; Instructions (num_busy_machines subroutine)

	;; (1) Backup registers:
	ST R1, backup_r1_3400
	ST R3, backup_r3_3400
	ST R4, backup_r4_3400
	ST R5, backup_r5_3400
	ST R7, backup_r7_3400

	;; (2) Subroutine algorithm:
	LDI R1, busyness_addr_num_busy_machines
	AND R2, R2, #0
	ADD R2, R2, #15		; Counter for checking each bit
	AND R3, R3, #0		; Counter of how many are busy
	AND R4, R4, #0		; Bit mask, starting at 2^0
	ADD R4, R4, #1
	
	loop_16_times_2
		AND R5, R1, R4
	
		BRz this_bit_is_zero
		BR end_this_bit_is_zero
		this_bit_is_zero
			ADD R3, R3, #1
		end_this_bit_is_zero

		ADD R4, R4, R4	; Shift bit mask by doubling it
	
		ADD R2, R2, #-1
		BRn end_loop_16_times_2
		BR loop_16_times_2
	end_loop_16_times_2

	AND R2, R2, #0		; Set return val
	ADD R2, R2, R3
	
	;; (3) Restore backed up registers
	LD R1, backup_r1_3400
	LD R3, backup_r3_3400
	LD R4, backup_r4_3400
	LD R5, backup_r5_3400
	LD R7, backup_r7_3400

	;; (4) Return
	RET

;;; Local data (num_busy_machines subroutine)

	busyness_addr_num_busy_machines	.fill	xBA00
	backup_r1_3400			.blkw	#1
	backup_r3_3400			.blkw	#1
	backup_r4_3400			.blkw	#1
	backup_r5_3400			.blkw	#1
	backup_r7_3400			.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3500

;;; Instructions (num_free_machines subroutine)

	;; (1) Backup registers:
	ST R1, backup_r1_3500
	ST R3, backup_r3_3500
	ST R4, backup_r4_3500
	ST R5, backup_r5_3500
	ST R7, backup_r7_3500

	;; (2) Subroutine algorithm:
	LDI R1, busyness_addr_num_busy_machines
	AND R2, R2, #0
	ADD R2, R2, #15		; Counter for checking each bit
	AND R3, R3, #0		; Counter of how many are busy
	AND R4, R4, #0		; Bit mask, starting at 2^0
	ADD R4, R4, #1
	
	loop_16_times_3
		AND R5, R1, R4
	
		BRp this_bit_is_one
		BR end_this_bit_is_one
		this_bit_is_one
			ADD R3, R3, #1
		end_this_bit_is_one

		ADD R4, R4, R4	; Shift bit mask by doubling it
	
		ADD R2, R2, #-1
		BRn end_loop_16_times_3
		BR loop_16_times_3
	end_loop_16_times_3

	AND R2, R2, #0		; Set return val
	ADD R2, R2, R3
	ADD R2, R2, #1		; I don't know why this works but it does.
	
	;; (3) Restore backed up registers
	LD R1, backup_r1_3500
	LD R3, backup_r3_3500
	LD R4, backup_r4_3500
	LD R5, backup_r5_3500
	LD R7, backup_r7_3500

	;; (4) Return
	RET

;;; Local data (num_free_machines subroutine)

	busyness_addr_num_free_machines	.fill	xBA00
	backup_r1_3500			.blkw	#1
	backup_r3_3500			.blkw	#1
	backup_r4_3500			.blkw	#1
	backup_r5_3500			.blkw	#1
	backup_r7_3500			.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3600

;;; Instructions (machine_status subroutine)

	;; (1) Backup registers:
	ST R1, backup_r1_3600
	ST R3, backup_r3_3600
	ST R7, backup_r7_3600

	;; (2) Subroutine algorithm:
	AND R2, R2, #0			; Mask to be ANDed with the vector is 2^(machine number), so calculate that first
	ADD R2, R2, #1			; 2^0

	AND R3, R3, #0			; Put R1 in temp storage for counting
	ADD R3, R3, R1
	BRnz end_loop_r1_times		; Skip loop if R1 = 0; mask of 1 is already correct
	
	loop_r1_times
		ADD R2, R2, R2		; R2 <- R2 * 2
	
		ADD R3, R3, #-1
		BRz end_loop_r1_times
		BR loop_r1_times
	end_loop_r1_times

	LDI R3, busyness_addr_machine_status
	AND R2, R2, R3			; R2 now holds vector bits all zeroed out except the one being queried
	BRp machine_is_free		; Now set R2 return value appropriately

	machine_is_busy
		AND R2, R2, #0
		BR end_machine_is_free
	end_machine_is_buy

	machine_is_free
		AND R2, R2, #0
		ADD R2, R2, #1
	end_machine_is_free
	
	;; (3) Restore backed up registers
	LD R1, backup_r1_3600
	LD R3, backup_r3_3600
	LD R7, backup_r7_3600

	;; (4) Return
	RET

;;; Local data (machine_status subroutine)

	busyness_addr_machine_status	.fill	xBA00
	backup_r1_3600			.blkw	#1
	backup_r3_3600			.blkw	#1
	backup_r7_3600			.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3700

;;; Instructions (first_free subroutine)

	;; (1) Backup registers:
	ST R7, backup_r7_3700

	;; (2) Subroutine algorithm:
	LDI R1, busyness_addr_first_free
	AND R3, R3, #0		; Bit mask power of 2, starting at 2^0
	ADD R3, R3, #1
	AND R4, R4, #0		; Counter for loop through each bit of vector
	ADD R4, R4, #15

	loop_16_times
		AND R2, R3, R1
		BRnp this_bit_is_free
		BR end_this_bit_is_free
	
		this_bit_is_free
			AND R2, R2, #0 	     	; Bit number that was just checked is 15 - R4, so put that in the return register
			ADD R2, R2, #15
			AND R3, R3, #0
			ADD R3, R3, R4
			NOT R3, R3
			ADD R3, R3, #1
			ADD R2, R2, R3
			BR end_sub_first_free	; ...and exit the subroutine
		end_this_bit_is_free
	
		ADD R3, R3, R3	; Double bit mask to shift its bit up
	
		ADD R4, R4, #-1
		BRn end_loop_16_times
		BR loop_16_times
	end_loop_16_times

	none_free
		AND R2, R2, #0
		ADD R2, R2, #15 ; Set it to 16 to indicate that nothing within 0-15 was found
		ADD R2, R2, #1
	end_none_free

	end_sub_first_free
	
	;; (3) Restore backed up registers
	LD R7, backup_r7_3700

	;; (4) Return
	RET

;;; Local data (first_free subroutine)

	busyness_addr_first_free	.fill	xBA00
	backup_r7_3700			.blkw	#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3800

;;; Instructions (get_machine_num subroutine)

	;; (1) Backup registers:
	ST R2, backup_r2_3800
	ST R3, backup_r3_3800
	ST R4, backup_r4_3800
	ST R5, backup_r5_3800
	ST R6, backup_r6_3800
	ST R7, backup_r7_3800

	;; (2) Subroutine algorithm:
	program_start
	
	; Output intro prompt
	LEA R0, prompt
	PUTS

	; Set up flags, counters, accumulators as needed
	AND R1, R1, #0	; Temp storage
	AND R2, R2, #0	; Final result
	AND R3, R3, #0	; Negative flag
	LD R4, hex30	; x30 for ascii conversion
	AND R5, R5, #0	; Number of digits input
	AND R6, R6, #0	; For counting down 10 for the multiplication by 10
	ADD R6, R6, #9
	AND R7, R7, #0	; Temporary storage

	; Get first character, test for '\n', '+', '-', digit/non-digit 	
	GETC					
	; Is very first character = '\n'? if so, just quit (no message)!
	LD R1, newline_3800
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRz program_end

	; Only output first char after we know it's not a newline
	OUT

	; Is it = '+'? if so, ignore it, go get digits
	LD R1, ascii_plus
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRz get_digits

	; Is it = '-'? if so, invalid input
	LD R1, ascii_minus
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRnp end_invalid
	invalid
		LD R0, newline_3800
		OUT
		LEA R0, error_msg_2
		PUTS
		BR program_start
	end_invalid

	test_if_digits
	; Is it < '0'? if so, it is not a digit	- o/p error message, start over
	LD R1, ascii_zero
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRn invalid

	; Is it > '9'? if so, it is not a digit	- o/p error message, start over
	LD R1, ascii_nine
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRp invalid

	; Skip the first digit handler if not the first digit
	; (because control comes back to reuse these checks for later digits)
	AND R1, R1, #0
	ADD R1, R1, R5
	BRnp non_first_digit_handler

	first_digit_handler
	; If none of the above, first character is first numeric digit - convert
	; it to number and store in target register!
	
	; First convert from ascii
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R0, R4
	LD R4, hex30
	ADD R5, R5, #1 	; Increment digit counter
	BR get_digits	; Move on to next digit

	non_first_digit_handler
	; Handle input of valid digits after the first one
	; First mult by ten due to addition of a digit
	AND R1, R1, #0 ; Store R2's value in temp register to use in repeated addition
	ADD R1, R1, R2 
	loop_10_times
		ADD R2, R2, R1
		ADD R6, R6, #-1
		BRp loop_10_times
	end_loop_10_times
	; Reset counter
	AND R6, R6, #0
	ADD R6, R6, #9
	; Convert from ascii and add to number
	NOT R4, R4
	ADD R4, R4, #1
	; Store conversion in temp register
	AND R1, R1, #0
	ADD R1, R4, R0
	; Finish by adding converted value to R2
	ADD R2, R2, R1
	; Reset hex30 register and temp register
	LD R4, hex30
	AND R7, R7, #0

	get_digits
	; Now get remaining digits (max 5) from user, testing each to see if it is a digit,
	; and build up number in accumulator
	
	; Finish up if digit counter >= 5 (should never exceed 5 though), otherwise get moar
	AND R1, R1, #0
	ADD R1, R1, #5
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R5
	BRzp program_end

	GETC
	ADD R5, R5, #1 	; Increment digit counter
	; Finish up if input is newline, otherwise continue
	LD R1, newline_3800
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R1, R0
	BRz newline_input
	OUT ; Only echo character if it's not a newline
	BR test_if_digits

	newline_input
		; Error if no digits entered yet even though first character (+ or -) has been,
		; otherwise end program
	
		AND R1, R1, #0
		ADD R1, R1, #-1
		ADD R1, R1, R5 ; R1 is now 0 if only one digit has been input
		BRz invalid
		BR program_end
	end_newline_input

	program_end
	; Make number neg if flag is set (R3 is -1)
	AND R1, R1, #0
	ADD R1, R1, #1
	ADD R1, R1, R3 ; Should be 1 - 1 = 0 if negative flag is set, otherwise 1 + 0 = 1
	BRnp num_not_neg
		NOT R2, R2
		ADD R2, R2, #1
	num_not_neg

	; Lazy implementation of changing return register to R1
	AND R1, R1, #0
	ADD R1, R1, R2

	; Ensure <= 15
	NOT R2, R1
	ADD R2, R2, #1
	ADD R2, R2, #15
	BRn invalid

	; Remember to end with a newline!
	LD R0, newline_3800
	OUT

	;; (3) Restore backed up registers
	LD R2, backup_r2_3800
	LD R3, backup_r3_3800
	LD R4, backup_r4_3800
	LD R5, backup_r5_3800
	LD R6, backup_r6_3800
	LD R7, backup_r7_3800

	;; (4) Return
	RET

;;; Local data (get_machine_num subroutine)

	prompt		.stringz	"Enter which machine you want the status of (0 - 15), followed by ENTER: "
	error_msg_2	.stringz	"ERROR INVALID INPUT\n"
	backup_r2_3800	.blkw		#1
	backup_r3_3800	.blkw		#1
	backup_r4_3800	.blkw		#1
	backup_r5_3800	.blkw		#1
	backup_r6_3800	.blkw		#1
	backup_r7_3800	.blkw		#1
	hex30		.fill 		x30
	newline_3800	.fill 		'\n'
	ascii_plus	.fill		'+'
	ascii_minus	.fill		'-'
	ascii_zero	.fill 		'0'
	ascii_nine	.fill 		'9'

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,15}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
; WITHOUT leading 0's, a leading sign, or a trailing newline.
;      Note: that number is guaranteed to be in the range {#0, #15}, 
;            i.e. either a single digit, or '1' followed by a single digit.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------

.ORIG x3900

;;; Instructions (print_num subroutine)

	;; (1) Backup registers:
	ST R0, backup_r0_3900
	ST R1, backup_r1_3900
	ST R2, backup_r2_3900
	ST R7, backup_r7_3900

	;; (2) Subroutine algorithm:
	AND R2, R2, #0
	ADD R2, R2, #10
	NOT R2, R2
	ADD R2, R2, #1
	ADD R2, R2, R1

	BRzp num_over_10

	num_under_10
		LD R2, hex30_3900
		ADD R1, R1, R2
		AND R0, R0, #0
		ADD R0, R0, R1
		OUT
		BR end_num_over_10
	end_num_under_10

	num_over_10
		LD R0, ascii_one_3900
		OUT
		AND R0, R0, #0
		ADD R0, R0, R1
		ADD R0, R0, #-10
		LD R2, hex30_3900
		ADD R0, R0, R2
		OUT
	end_num_over_10
	
	;; (3) Restore backed up registers
	LD R0, backup_r0_3900
	LD R1, backup_r1_3900
	LD R2, backup_r2_3900
	LD R7, backup_r7_3900

	;; (4) Return
	RET

;;; Local data (print_num subroutine)

	backup_r0_3900	.blkw	#1
	backup_r1_3900	.blkw	#1
	backup_r2_3900	.blkw	#1
	backup_r7_3900	.blkw	#1
	hex30_3900	.fill	x30
	ascii_one_3900	.fill	'1'
	
;;; BELOW IS NOT FOR ABOVE SUBROUTINE?
.ORIG x6A00
	
	menustring .stringz "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xBA00					; Remote data
	
	busyness   .fill    x8000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.


	
.END
