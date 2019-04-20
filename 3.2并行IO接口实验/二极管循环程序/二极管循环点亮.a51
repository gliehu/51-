MOV	SP,	#60H
MOV	P0,	#0FFH
MOV	A,	#0FEH

START:
MOV	 P0,	 A
RL	 A
CALL	 DELAY
SJMP	 START

DELAY: MOV 		R6,		#248    ;…®√Ë—” ±
D3:    MOV 		R7,		#248
D4:	 MOV		R5,		#10
	 DJNZ 	R5,		$
       DJNZ 	R7,		D4
       DJNZ 	R6,		D3
       RET
END