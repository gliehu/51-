LATCH1 BIT P2.2
LATCH2 BIT P2.3


START:
      MOV 		DPTR,		#TABLE
      MOV 		SP,		#60H
	MOV 		R1,		#01H ;指针，访问码	  
	MOV 		R3,		#11111110B;位码初值
	     

SCAN:	
	MOV 		A,R1
	MOVC 		A, 		@A+DPTR
	MOV 		P0,A
	SETB 		LATCH1
	CLR 		LATCH1
	MOV 		P0,		R3
	SETB 		LATCH2
	CLR 		LATCH2
	CALL 		DELAY

	INC 		R1
	MOV 		A,		R3
	RL  		A
	MOV 		R3,		A
	 
	CJNE 		R1,		#09H,		SCAN
	MOV 		R1,		#01H
	LJMP 		SCAN
			      

DELAY: MOV 		R6,		#4    ;扫描延时
D3:    MOV 		R7,		#248
       DJNZ 	R7,		$
       DJNZ 	R6,		D3
       RET
   
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;共阴字码表

END