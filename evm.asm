#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=0FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#





; add your code here
         jmp     st1 
         db      125 dup(0)
         
;IVT entry for 80H
         
         dw ISR_INT2
         dw 0000h
		 
		 db      892 dup(0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; IVT has to be put here								;vector no. 32

portA1		equ		00h 					;8255(For KeyPad)
portB1		equ		02h
portC1		equ		04h
CW1			equ		06h

portA2		equ		10h 					;8255(For LCD)
portB2		equ		12h
portC2		equ		14h
CW2			equ		16h

cntReg0		equ		30h 					;8253(Timer)
cntReg1		equ 	32h
cntReg2  	equ 	34h
cReg 		equ 	36h


TABLE_K			DW		1E1EH,1E1DH,1E1BH,1E17H,1E0FH
				DW		1D1EH,1D1DH,1D1BH,1D17H,1D0FH
				DW		1B1EH,1B1DH,1B1BH,1B17H,1B0FH
				DW		171EH,171DH,171BH,1717H,170FH
				DW		0F1EH,0F1DH,0F1BH,0F17H,0F0FH


DATA_K			DW		0F001H,0F002H,0F003H,0F004H,0F005H
				DW		0F006H,0F007H,0F008H,0E001H,0E002H
				DW		0030H,0031H,0032H,0033H,0034H
				DW		0035H,0036H,0037H,0038H,0039H
				DW		000AH,000BH,0041H,0042H,0043H
 


				
;vote tally stored
c1votes dw ?
c2votes dw ?
c3votes dw ?
c4votes dw ?
c5votes dw ?
c6votes dw ?
c7votes dw ?
c8votes dw ?

;value of key for officer keypad
c1 			equ 		0031H 
c2 			equ			0032H
c3 			equ 		0033H
c4 			equ 		0034H
c5 			equ 		0035H
c6 			equ 		0036H
c7 			equ 		0037H
c8 			equ 		0038H
tvote 		equ			0030H
dis 		equ 		0E002H
enterkey 	equ 		0042H
exit 		equ			0043H
backspace 	equ 		0041H

;value of key for voter keypad
c1key 	dw 	0F001h 
c2key 	dw 	0F002h
c3key 	dw 	0F003h
c4key 	dw 	0F004h
c5key 	dw 	0F005h
c6key 	dw 	0F006h
c7key 	dw 	0F007h
c8key 	dw 	0F008h
cakey	dw	000AH
temp    DW  ?
temp3	dw 	?
temp2	db 	5 dup(?)

;passwords
passwd1 db 	'11111'
passwd2 db 	'22222'
passwd3 db 	'33333'
passwd4 db 	'44444'
passwd5 db 	'55555'
passwd6 db 	'66666'
passwd7 db 	'77777'
passwd8 db 	'88888'
passadm db	'99999'
locker  db  '00000'
unlocker db '11111'
pollvotes db '00000'


;main program
          
st1:      sti 
; intialize ds, es,ss to start of RAM
          mov       ax,0000h
          mov       ds,ax
		  mov       ax,0200h
          mov       es,ax
          mov       ss,ax
          mov       sp,0FFEH	;Initializing SP

          mov 		AL,10010000b		;Port A in inp mode for rows and Port B in out mode for columns
    	  out 		CW1,AL				;Initialize 8255 at 00H for Keypad
	      mov 		AL,10000000b		;Port A, B and C in outp mode for LCD 
          out 		CW2,AL				;Initialize 8255 at 10H for LCD


			
;main function
			jmp START

ALARM:		
            call raise_alarm
START:  
			mov     dx,0000h			;Initialize memory locations for count storage with 0000h
			mov 	c1votes,dx
			mov		c2votes,dx
			mov		c3votes,dx
			mov		c4votes,dx
			mov		c5votes,dx
			mov		c6votes,dx
			mov		c7votes,dx
			mov		c8votes,dx
			
			
			call 	initialise_lcd
			call 	clear_lcd
									
	;checking correctness of each candidate one by one
	m1:		call 	disp_c1
			call 	disp_passwd
			LEA 	SI,passwd1
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			
			call 	disp_correct
			
	m2:		call 	disp_c2
			call 	disp_passwd
			LEA 	SI,passwd2                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m3:		call 	disp_c3
			call 	disp_passwd
			LEA 	SI,passwd3                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m4:		call 	disp_c4
			call 	disp_passwd
			LEA 	SI,passwd4                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m5:		call 	disp_c5
			call 	disp_passwd
			LEA 	SI,passwd5                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m6:		call 	disp_c6
			call 	disp_passwd
			LEA 	SI,passwd6                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m7:		call 	disp_c7
			call 	disp_passwd
			LEA 	SI,passwd7
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m8:		call 	disp_c8
			call 	disp_passwd
			LEA 	SI,passwd8                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
	m9:		call 	disp_admin
			call 	disp_passwd
			LEA 	SI,passadm                   
			CALL    CHECKPASS
			cmp 	bp,0h
			jz 		system_exit
			call 	disp_correct
			
			
			
			mov 	AL,00110100b		;Setting counter0 to mode 2
			out		cReg,AL
			
			mov 	AL,0c4h				;Count of counter0 is 2500
			out		cntReg0,AL
			mov 	AL,09h
			out		cntReg0,AL
			
			mov 	AL,01110100b		;Setting counter1 into mode 2
			out		cReg,AL
			
			mov 	AL,0e8h				;count of counter1 is 1000
			out		cntReg1,AL
			mov 	AL,03h
			out		cntReg1,AL
			
			mov 	AL,10110100b		;Setting counter2 into mode 2
			out		cReg,AL
			
			mov 	AL,0A0h				;count of counter2 is 36000 (10 hours)
			out		cntReg2,AL
			mov 	AL, 8Ch
			out		cntReg2,AL
			
			call 	disp_start_voting

	fetchVote:
			CALL    GetVotingData
			jmp		fetchVote			

					
;ISR called when lock key is pressed
			
isr_1:			
			call 	disp_ent_pass			;ask for password
			lea si,	locker					;locker is the address of password to lock
			call 	CHECKPASS1				
			cmp 	bp,0000h
			jz 		y4						;if wrong password, then display incorrect and go to iret
		
		lk1: 	
			call 	getKeyData
			cmp 	bx, enterkey
			jnz 	lk1
			call	disp_locked				;if correct password output then system locked
			jmp 	y2
	
	y5:		
			call 	disp_locked
			
	y2:		call 	getKeyData
			
			cmp 	bl,000bh					 
			jnz 	y2
			
			call 	disp_ent_pass				;ask for password
			lea 	si,unlocker					;unlocker is the address of password to unlock
			call 	CHECKPASS1				
			cmp 	bp,0000h
			jz 		y5							;if wrong password output display incorrect, jump to y5

		lk2: 	
			call 	getKeyData
			cmp 	bx, enterkey
			jnz 	lk2
			call 	disp_unlocked					;if correct output unlocked and get out of isr
			jmp 	y3
	
	y4:		
			call disp_not_locked
			call clear_lcd
	
	y3:		jmp final
			
	


;to get data from keypressed


getKeyData 	proc 	near

			MOV 	AL,00H
			OUT 	portB1,al							;portB is column hence initialise to all 0s
key_release1:
			in 		al,portA1
			cmp 	al,01Fh
			jnz 	key_release1

keypad_check:
	
		MOV 	AL,00H
		OUT 	portB1,al
		in 		al,portA1				;To check the key press to eliminate errors due to debounce
		cmp		al,01Fh
		jz 		keypad_check				

		MOV 	AL,00H
		OUT 	portB1,al

		in 		al,portA1
		cmp		al,01Fh
		jz		keypad_check			

		;check each column 0 to 4 one by one to understand which key is pressed
		mov		al,1Eh				
		mov		bl,al
		out		portB1,al
		in 		al,portA1
		cmp		al,01Fh
		jnz		getData

		mov		al,1Dh				
		mov		bl,al
		out		portB1,al
		in 		al,portA1
		cmp		al,01Fh
		jnz		getData

		mov		al,1Bh	
		mov		bl,al
		out		portB1,al
		in 		al,portA1
		cmp		al,01Fh
		jnz		getData

		mov		al,17h				
		mov		bl,al
		out		portB1,al
		in 		al,portA1
		cmp		al,01Fh
		jnz		getData

		mov		al,0Fh		
		mov		bl,al
		out		portB1,al
		in 		al,portA1
		cmp		al,01Fh
		jnz		getData
		jmp		keypad_check

getData:
		mov		bh,al 				;The BX register now contains HEX code for the keyPress as bl stores column and bh stores row
		mov 	al,bl
		mov		CX,25d				;since the keypad has 25 keys, we need to iterate that many times
		mov		DI,00h				
x4:							
		cmp		BX,TABLE_K[DI]
		jz 		x5
		inc		DI
		inc		DI
		loop 	x4
x5:		
		mov 	bx,DI
		mov 	si,offset DATA_K
		mov 	al,[si+bx]
		mov 	ah,[si+bx+1]			
		mov    	bx,ax				;BX has the 16 bit key value which is passed to subroutines calling getKeyData
		RET

getKeyData 		endp



;function for delay
delay 		proc	near
			push 	cx
			mov 	cx,900d
dl1:		nop		;3 CLK CYCLES
		
			loop 	dl1	;18 CYCLES IF JMP IS TAKEN, 5 OTHER WISE
			pop 	cx	;by now 3*900+18*899+5=18887 cycles done. DELAY GENERATED BASED ON CLK(10mhz)=1.8887ms
			ret
delay 		endp

delay2 		proc	near
			push 	cx
			mov 	cx,3000d
dl2:		nop		;3 CLK CYCLES
			nop		;3 CLK CYCLES
			loop 	dl2	;18 CYCLES IF JMP IS TAKEN, 5 OTHER WISE
			pop 	cx	;by now 6*3000+18*2999+5= 18000+53982+5cycles done. DELAY GENERATED BASED ON CLK(10mhz)=1.8887ms
			ret	
delay2 		endp

delay3		proc 	near
			push cx
				mov cx,20
	looper:		call delay
				call delay
				call delay
				loop looper
			pop cx
			ret
delay3		endp
			

;checking password
CHECKPASS	proc	 near
			mov 	temp,si
			mov 	bp, 3h

candidate_auth1:	
			mov 	si,temp
			call 	clear_lcd
			lea 	di, temp2
			mov		dx,0005h		;password is 5 characters long

	passwordinp3:
		    
			push 	si     ; getKeyData will use si,cx hence push onto stack
			push 	di
			call 	getKeyData
			mov 	al,bl
			pop 	di
			pop 	si
			cmp 	bx,backspace
			jnz 	x1
			call 	shift_left 
			call 	delay3
			call 	delay3
			call 	delay3
			dec 	di
			inc 	dx
			jmp 	passwordinp3

	x1:		mov 	DS:[di],Bl
			mov 	al,ds:[di]
			call 	write_lcd
			inc 	di
			dec 	dx
	x2:		jnz 	passwordinp3

			push 	si
			push 	di
		e1:	call 	getKeyData
			cmp 	bx, enterkey
			jnz 	e1
			pop 	di
			pop 	si
			
			mov 	dx,0005h 
			lea 	di,temp2
checkwrong:			
			mov 	Bl,DS:[di]			
			cmp		Bl,ds:[SI]	
			jnz		wronginp3	
			inc		si	
			inc 	di
			dec 	dx
			cmp 	dx,0h
			jnz 	checkwrong
			ret
		wronginp3:
			
			CALL 	disp_incorrect					
			dec 	bp
			cmp 	bp,0h
			jnz		candidate_auth1				;CALL RAISE ALARM (Raise the LED and restart the system). This is done at the end of taking i/p from each candidate	
			call 	raise_alarm
			ret	
CHECKPASS	endp	

;for lock unlock and poll
CHECKPASS1  proc    near						
			mov 	temp,si
			mov 	bp, 1h
candidate_auth2:	
			mov 	si,temp
			call 	clear_lcd
			lea 	di, temp2
			mov		dx,0005h		;5 characters in the password

		passwordinp4:
			push 	si     ; getKeyData will use si,cx hence push onto stack
			push 	di
			call 	getKeyData
			mov 	al,bl
			pop 	di
			pop 	si
			cmp 	bx,backspace
			jnz 	x3
			call 	shift_left 
			call 	delay3
			dec 	di
			inc 	dx
			jmp 	passwordinp4
	x3:		mov 	DS:[di],Bl
			mov 	al,ds:[di]
			call 	write_lcd
			inc 	di
			dec 	dx
	x8:		jnz 	passwordinp4

			push 	si
			push 	di
		e2:	call 	getKeyData
			cmp 	bx, enterkey
			jnz 	e2
			pop 	di
			pop 	si
			
			mov 	dx,0005h 
			lea 	di,temp2

checkwrong2:			
			mov 	Bl,DS:[di]			
			cmp		Bl,ds:[SI]	
			jnz		wronginp4	
			inc		si	
			inc 	di
			dec 	dx
			cmp 	dx,0h
			jnz 	checkwrong2
			ret
		wronginp4:
			
			CALL 	disp_incorrect		
			dec 	bp
			cmp 	bp,0h
			jnz		candidate_auth2					
			call 	raise_alarm
			ret	
CHECKPASS1  endp




;getting votes from the voter's keypad
GetVotingData 		proc 	near

			 		CALL 	getKeyData
					cmp  	bx,c1key
					jnz  	candidate2
					mov 	al,01
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c1votes		
					mov 	ax,c1votes
					add 	al,30h
					jmp	 	final
		candidate2: 
					cmp  	bx,c2key
					jnz  	candidate3
					mov 	al,02h
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c2votes
					mov 	ax,c2votes
					add 	al,30h
					jmp	 	final
		candidate3: 
					cmp  	bx,c3key
					jnz  	candidate4
					mov 	al,04h
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c3votes
					mov 	ax,c3votes
					add 	al,30h
					jmp	 	final
		candidate4: 
					cmp  	bx,c4key
					jnz  	candidate5
					mov 	al,08H
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c4votes
					mov 	ax,c4votes
					add 	al,30h
					jmp	 	final
		candidate5: 
					cmp  	bx,c5key
					jnz  	candidate6
					mov 	al,10H
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c5votes
					mov 	ax,c5votes
					add 	al,30h
					jmp	 	final
		candidate6: 
					cmp  	bx,c6key
					jnz  	candidate7
					mov		al,20H
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c6votes
					mov 	ax,c6votes
					add 	al,30h
					jmp	 	final
		candidate7: 
					cmp  	bx,c7key
					jnz  	candidate8
					mov 	al,40H
					out 	portB2,al
					call	 delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c7votes
					mov 	ax,c7votes
					add 	al,30h
					jmp	 	final
		candidate8: 
					cmp  	bx,c8key
					jnz  	ca
					mov 	al,80H
					out 	portB2,al
					call 	delay
					call 	delay2
					call 	delay3
					call 	delay3
					call 	delay3
					call 	delay3
					mov 	al,00
					out 	portB2,al
					call 	disp_voted
					inc  	c8votes
					mov 	ax,c8votes
					add 	al,30h
					jmp	 	final

		ca:			
					cmp  	bx,cakey
					jnz  	final
					jmp 	isr_1
		final:	
					ret
GetVotingData 		endp


	
;LCD functions
initialise_lcd		proc 	near

				mov 	al,10000000b		;Initialising 8255
				out 	CW2,al				;portA2 is connected to the data lines of LCD and portC2 is connected to control pins of LCD

				;STEP 1
				mov 	al,00110000b		
				out 	portA2,al			;function setting over
				mov 	al, 00100000b		;set E=0 deactivate LCD using 02H (has to be done after every command)
				out 	portC2,al		
				mov 	al, 00000000b		;set E=1 activate LCD using 00H (has to be done after every command)
				out 	portC2,al		
				call 	delay
							
				;STEP2
				mov 	al,00001110b		;0E switches on display and cursor
				out 	portA2,al			
				mov 	al,00100000b		
				out 	portC2,al			
				mov 	al, 00000000b		
				out 	portC2,al
				call 	delay
		
				;STEP3
				mov 	al,00000110b		;06H increments cursor	
				out 	portA2,al			
				mov 	al,00100000b		
				out 	portC2,al
				mov 	al, 00000000b		
				out 	portC2,al		
				call 	delay
				ret
initialise_lcd	endp

shut_lcd		proc 	near
				mov 	al, 08H				;cursor and display both turned off
				out 	portA2, al
				mov 	al,00100000b		
				out 	portC2,al
				mov 	al, 00000000b		
				out 	portC2,al
				call 	delay
				ret
shut_lcd 		endp

shift_left		proc 	near
				mov 	al,10H					;shift cursor left
				out 	portA2, al
				mov 	al,00100000b
				out 	portC2, al
				mov 	al, 00H
				out 	portC2, al
				call 	delay
				mov 	al,' '
				call 	write_lcd
				mov 	al,10H
				out 	portA2, al
				mov 	al,00100000b
				out 	portC2, al
				mov 	al, 00H
				out 	portC2, al
				call 	delay
				ret
shift_left		endp
				
				
write_lcd		proc 	near				;AL contains ASCII value
				out 	portA2,al						
				mov 	al,10100000b		;setting to write mode		;pc7-1,pc6-0,p5=0
				out 	portC2,al
				mov 	al, 10000000b		;set E=1;
				out 	portC2,al
				push 	cx
				mov 	cx,10
		d:		call 	delay
				call 	delay
				call 	delay
				loop 	d
				pop 	cx
				ret
write_lcd		endp

clear_lcd		proc 	near
				mov 	al,00000001b
				out 	portA2,al			;lcd cleared
				mov 	al,00100000b		;clearing display of lcd		;pc7,pc6-0,p5=0
				out 	portC2,al
				mov 	al, 00000000b		;set E=1;
				out 	portC2,al		
				call 	delay				
				ret
clear_lcd		endp

disp_locked		proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'L'
				call 	write_lcd
				mov 	al,'o'			
				call 	write_lcd
				mov 	al,'c'
				call 	write_lcd
				mov 	al,'k'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				ret
disp_locked		endp
		
disp_goodbye 	proc 	near
				call 	clear_lcd
				call 	delay
				call 	delay
				mov 	al,'G'
				call 	write_lcd
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'D'
				call 	write_lcd
				mov 	al,'B'
				call 	write_lcd
				mov 	al,'Y'
				call 	write_lcd
				mov 	al,'E'
				call 	write_lcd
				call 	delay3
				ret
disp_goodbye 	endp

disp_unlocked	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'U'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'l'
				call 	write_lcd
				mov 	al,'o'				
				call 	write_lcd
				mov 	al,'c'
				call 	write_lcd
				mov 	al,'k'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				call 	delay3
				call 	clear_lcd
				ret
disp_unlocked	endp

disp_correct	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'C'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'c'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				call 	delay3
				ret
disp_correct	endp

disp_incorrect	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'I'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'c'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'c'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				call 	delay3
				ret
disp_incorrect	endp

disp_ent_pass	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'E'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				mov 	al,'P'
				call 	write_lcd
				mov 	al,'a'
				call 	write_lcd
				mov 	al,'s'
				call 	write_lcd
				mov 	al,'s'
				call 	write_lcd
				mov 	al,'w'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				call 	delay3
				ret
disp_ent_pass	endp

disp_cand_num	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'E'
				call 	write_lcd
				mov 	al,'n'
				call	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'r'
				call	 write_lcd
				mov 	al,' '
				call 	write_lcd
				mov 	al,'C'
				call 	write_lcd
				mov 	al,'a'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				mov 	al,'i'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				mov 	al,'a'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				call 	delay3
				ret
disp_cand_num 	endp

disp_c1			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'1'
				call 	write_lcd
				ret
disp_c1			endp

disp_c2			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'2'
				call 	write_lcd
				ret
disp_c2			endp

disp_c3			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'3'
				call 	write_lcd
				ret
disp_c3			endp

disp_c4			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov	 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'4'
				call 	write_lcd
				ret
disp_c4			endp

disp_c5			proc 	near
				call 	clear_lcd		
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'5'
				call 	write_lcd
				ret
disp_c5			endp

disp_c6			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'6'
				call 	write_lcd
				ret
disp_c6			endp

disp_c7			proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'7'
				call 	write_lcd
				ret
disp_c7			endp

disp_c8			proc 	near
				call 	clear_lcd	
				call 	delay
				call 	delay
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'F'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'8'
				call 	write_lcd
				ret
disp_c8			endp

disp_admin		proc 	near
				call 	clear_lcd		
				call 	delay
				call 	delay
				mov 	al,'P'
				call 	write_lcd
				mov 	al,'R'
				call 	write_lcd
				mov 	al,'.'
				call 	write_lcd
				mov 	al,'O'
				call 	write_lcd
				mov 	al,'.'
				call 	write_lcd
				ret
disp_admin		endp

disp_voted		proc 	near
				call 	clear_lcd		
				call 	delay
				call 	delay
				mov 	al,'V'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				call 	clear_lcd
				ret
disp_voted      endp

disp_candidate	proc 	near
				call 	clear_lcd			
				call 	delay
				call 	delay
				mov 	al,'C'
				call 	write_lcd
				mov 	al,'A'
				call 	write_lcd
				mov 	al,'N'
				call 	write_lcd
				mov 	al,'D'
				call 	write_lcd
				mov 	al,'.'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_candidate	endp

disp_v1			proc 	near
				mov 	al,'1'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v1			endp

disp_v2			proc 	near
				mov 	al,'2'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v2			endp

disp_v3			proc 	near
				mov 	al,'3'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v3			endp

disp_v4			proc 	near
				mov 	al,'4'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v4			endp

disp_v5			proc 	near
				mov 	al,'5'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v5			endp

disp_v6			proc 	near
				mov 	al,'6'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v6			endp

disp_v7			proc 	near
				mov 	al,'7'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v7			endp

disp_v8			proc 	near
				mov 	al,'8'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				ret
disp_v8			endp


disp_passwd		proc 	near
				mov 	al,' '
				call 	write_lcd
				mov 	al,'P'
				call 	write_lcd
				mov 	al,'a'
				call 	write_lcd
				mov 	al,'s'
				call 	write_lcd
				mov 	al,'s'
				call 	write_lcd
				mov 	al,'w'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				call 	delay3
				ret
disp_passwd		endp

disp_start_voting proc 	near
				call 	clear_lcd
				call 	delay
				call 	delay
				mov 	al,'S'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'a'
				call 	write_lcd
				mov 	al,'r'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				mov 	al,'V'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov		al,'i'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'g'
				call 	write_lcd
				call 	delay3
				call 	clear_lcd
				ret
disp_start_voting 		endp	

disp_end_voting proc 	near
				call 	clear_lcd
				call 	delay
				call 	delay
				mov 	al,'E'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'d'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				mov 	al,'V'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'i'
				call 	write_lcd
				mov 	al,'n'
				call 	write_lcd
				mov 	al,'g'
				call 	write_lcd
				call 	delay3
				call 	clear_lcd
				ret
disp_end_voting endp

disp_total_votes proc 	near
				call 	clear_lcd
				call 	delay
				call 	delay
				mov 	al,'T'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				mov 	al,'V'
				call 	write_lcd
				mov 	al,'o'
				call 	write_lcd
				mov 	al,'t'
				call 	write_lcd
				mov 	al,'e'
				call 	write_lcd
				mov 	al,'s'
				call 	write_lcd
				mov 	al,':'
				call 	write_lcd
				mov 	al,' '
				call 	write_lcd
				call 	delay3
				ret
disp_total_votes endp


disp_not_locked 	proc 	near
					call 	clear_lcd
					call 	delay
					call 	delay
					mov 	al,'N'
					call 	write_lcd
					mov 	al,'o'
					call 	write_lcd
					mov 	al,'t'
					call 	write_lcd
					mov 	al,' '
					call 	write_lcd
					mov 	al,'L'
					call 	write_lcd
					mov 	al,'o'
					call 	write_lcd
					mov 	al,'c'
					call 	write_lcd
					mov 	al,'k'
					call 	write_lcd
					mov 	al,'e'
					call 	write_lcd
					mov 	al,'d'
					call 	write_lcd
					call 	delay3
					ret
disp_not_locked     endp			
				
raise_alarm		proc 	near                                            
                call 	disp_goodbye
				call 	delay3
				call 	shut_lcd
				ret
raise_alarm		endp

ISR_INT2:
	
	keepPolling:
				CALL 	disp_end_voting
				CALL 	getKeyData	
				CMP 	BX,exit
				jz 		system_exit
				CMP 	BX,0E001H
				JNZ 	keepPolling
		V1:		CALL 	disp_ent_pass
				LEA 	SI,pollvotes
				CALL 	CHECKPASS1
				CMP 	BP,00H
				JZ 		V1

		V2:		CALL 	disp_cand_num	
				call 	clear_lcd
				CALL 	getKeyData
				CMP 	BX,exit
				jz 		system_exit
				mov 	al,bl
				call 	write_lcd
				MOV 	DX,c1								
				CMP 	BX,DX
				JNZ 	CANDIDATE_2
			l1:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l1
				call 	disp_candidate
				call 	disp_v1
				MOV 	dx,c1votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP V2

	CANDIDATE_2:
				MOV 	DX,c2
				CMP 	BX,DX
				JNZ 	CANDIDATE_3
				l2:		CALL getKeyData
				CMP		BX,dis
				JNZ 	l2
				call 	disp_candidate
				call 	disp_v2
				MOV 	dx,c2votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	CANDIDATE_3:
				MOV 	DX,c3
				CMP 	BX,DX
				JNZ 	CANDIDATE_4
			l3:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l3
				call 	disp_candidate
				call 	disp_v3
				MOV 	dx,c3votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	CANDIDATE_4:
				MOV 	DX,c4
				CMP 	BX,DX
				JNZ 	CANDIDATE_5
			l4:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l4
				call 	disp_candidate
				call 	disp_v4
				MOV 	dx,c4votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2


	CANDIDATE_5:
				MOV 	DX,c5
				CMP 	BX,DX
				JNZ 	CANDIDATE_6
			l5:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l5
				call 	disp_candidate
				call 	disp_v5
				MOV 	dx,c5votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	CANDIDATE_6:
				MOV 	DX,c6
				CMP 	BX,DX
				JNZ 	CANDIDATE_7
			l6:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l6
				call 	disp_candidate
				call 	disp_v6
				MOV 	dx,c6votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	CANDIDATE_7:
				MOV 	DX,c7
				CMP 	BX,DX
				JNZ 	CANDIDATE_8
			l7:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l7
				call 	disp_candidate
				call 	disp_v7
				MOV 	dx,c7votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	CANDIDATE_8:
				MOV 	DX,c8
				CMP 	BX,DX
				JNZ 	TOTALVOTES
			l8:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l8
				call 	disp_candidate
				call 	disp_v8
				MOV 	dx,c8votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

	TOTALVOTES:
				MOV 	DX,tvote
				CMP 	BX,DX
				JNZ 	V2
			l9:	CALL 	getKeyData
				CMP		BX,dis
				JNZ 	l9
				call 	disp_total_votes
				MOV 	dx,c8votes
				add 	dx,c1votes
				add 	dx,c2votes
				add 	dx,c3votes
				add 	dx,c4votes
				add 	dx,c5votes
				add 	dx,c6votes
				add 	dx,c7votes
				call 	convertToBCD
				call 	disp_vote_cnt
				JMP 	V2

		IRET

	
convertToBCD	proc	near
				mov		AX,0000H
				mov		CX,0
				
		d1:

				inc     cx				
				SHL     AX,1
				SHL 	DX,1			;Hex Data to be converted to BCD form is in DX
				jnc	    d2
				inc 	AX
		d2:
				cmp    	cx,16
				jz 	   	finish
		
				mov    	bl,ah		;BIN-4
				and    	bl,0F0h
				rol    	bl,1
				rol    	bl,1
				rol    	bl,1
				rol    	bl,1
				cmp    	bl,5
				jb     	d3
				add    	AX,3000h

		d3:
				mov	   	bl,ah 		;BIN-3
				and    	bl,0Fh
				cmp	   	bl,5
				jb	   	d4
				add    	AX,0300h
		d4:
				mov    	bl,al		;BIN-2
				and    	bl,0F0h
				rol    	bl,1
				rol    	bl,1
				rol    	bl,1
				rol    	bl,1
				cmp    	bl,5
				jb     	d5
				add    	AX,0030h	
		d5:
				mov	   	bl,al 		;BIN-1
				and    	bl,0Fh
				cmp    	bl,5
				jb     	d6
				add    	AX,0003h

		d6:
				cmp   	cx,16
				ja 		finish
				jmp 	d1

		finish:
				ret
convertToBCD 	endp

disp_vote_cnt 	proc 	near
				mov    	cx,AX
				mov    	bh,ah
				and    	bh,0F0h
				rol    	bh,1
				rol    	bh,1
				rol    	bh,1
				rol    	bh,1
				mov    	AX,cx

				mov    	cx,AX
				add     bh,30h
				mov    	al,' '
				call   	write_lcd
				mov    	al,bh 		; To display one character
				call   	write_lcd
				mov    	AX,cx
				
				mov    	cx,AX
				mov    	bh,ah
				and    	bh,0Fh
				mov    	AX,cx

				mov    	cx,AX
				add     bh,30h
				mov 	al,bh  		
				call   	write_lcd
				mov    	AX,cx

				mov    	cx,AX
				mov    	bh,al
				and    	bh,0F0h
				rol    	bh,1
				rol    	bh,1
				rol    	bh,1
				rol    	bh,1
				mov    	AX,cx
				
				mov    	cx,AX
				add     bh,30h
				mov 	al,bh 		
				call   	write_lcd
				mov    	AX,cx

				mov    	cx,AX
				mov    	bh,al
				and    	bh,0Fh
				mov    	AX,cx

				mov    	cx,AX
				add     bh,30h
				mov 	al,bh  		
				call   	write_lcd
				mov    	AX,cx
				push 	cx
				mov 	cx,30
	loo3:		call 	delay
				call 	delay
				call 	delay
				loop 	loo3
				pop 	cx
				call 	clear_lcd
				ret
disp_vote_cnt	endp


system_exit:
			 call 	disp_goodbye
			 call 	shut_lcd

			 
system_exit2: jmp 	system_exit2
