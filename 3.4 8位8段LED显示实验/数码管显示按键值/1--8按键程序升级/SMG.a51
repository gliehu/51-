;按键Ki显示对应数字i
;编写人：高洪伟
;编写日期2019-4-9
;修改日期2019-4-10
;R1提供段码表偏移地址
;R3存放位码

LATCH1 BIT P2.2	
LATCH2 BIT P2.3	


START:
      MOV 	  DPTR,	#TABLE
      MOV 	  SP,		#60H
	MOV  	  P1,		#0FFH ;先写1再读引脚
	
	JNB	P1.0,		KEY1 
	JNB  	P1.1,		KEY2
	JNB  	P1.2,		KEY3
	JNB  	P1.3,		KEY4 
	JNB  	P1.4,		KEY5
	JNB  	P1.5		KEY6	  
	JNB  	P1.6,		KEY7 
	JNB  	P1.7,		KEY8 ;target out of range,超过2K不能跳转，可加一条中转指令	  
	LJMP  START

;数码管显示
SCAN:	
     MOV 	A,		R1
     MOVC 	A, 		@A+DPTR
     MOV 	P0,		A
     SETB 	LATCH1
     CLR 	LATCH1
     MOV 	P0,		R3
     SETB 	LATCH2
     CLR 	LATCH2
     CALL 	DELAY
     LJMP 	START

KEY1:	
	MOV 	R1,	#01H 	    ;访问段码	  
	MOV 	R3,	#11111110B;位码初值
	LJMP 	SCAN
KEY2:
	MOV 	R1,	#02H      ;访问段码	  
	MOV 	R3,	#11111101B;位码初值
	LJMP 	SCAN
KEY3:
	MOV 	R1,	#03H      ;访问段码	  
	MOV 	R3,	#11111011B;位码初值
	LJMP 	SCAN
KEY4:
	MOV 	R1,	#04H      ;访问段码	  
	MOV 	R3,	#11110111B;位码初值
	LJMP 	SCAN
KEY5:
	MOV 	R1,	#05H      ;访问段码	  
	MOV 	R3,	#11101111B;位码初值
	LJMP 	SCAN
	 
KEY6:
	MOV 	R1,	#06H      ;访问段码	  
	MOV 	R3,	#11011111B;位码初值
	LJMP 	SCAN
     	 
KEY7:
	MOV 	R1,	#07H      ;访问段码	  
	MOV 	R3,	#10111111B;位码初值
	LJMP 	SCAN 
KEY8:
	MOV 	R1,	#08H      ;访问段码	  
	MOV 	R3,	#01111111B;位码初值
	LJMP 	SCAN
  
DELAY: MOV 	R6,	#4    ;扫描延时
D3:    MOV 	R7,	#248
       DJNZ R7,	$
       DJNZ R6,	D3
       RET  
	 
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;共阴字码表

END