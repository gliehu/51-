;串口发送程序
;编写人：高洪伟
;编写日期2019-4-19
;修改日期2019-4-20
;T0中断时，R1指向26H-29H，分别存储毫秒，秒，分，时
;T0中R0扫描段码
;STORE函数中：分别计算毫秒，秒，分，时的段码，存储在1DH--24H
;T1中断方式二，提供波特率4800
;R3存储位码值，左移


LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START ;主程序
ORG 0003H
LJMP INT_0 ;按键中断
ORG 000BH
LJMP T0_INT ;定时器0，1ms
ORG 001BH
LJMP T1_INT ;定时器1，串口波特率4800
ORG 0023H
LJMP COM_INT 	;串口，10ms
START:
	  MOV  TCON,	#51H
	  MOV	 SCON,	#40H	
	  MOV	 PCON,	#00H
	  MOV  IP,		#10H
	  ;MOV  IE,		#9BH
	  MOV  TMOD,	#21H	 ;T0工作在方式1，T1方式二
	  MOV  TL0,		#018H
	  MOV  TH0,		#0FCH   ;1ms中断
	  MOV  TL1,		#0FAH
	  MOV  TH1,		#0FAH  ;10ms中断
        MOV  DPTR,	#TABLE
        MOV  SP,		#60H      	 
	  MOV  32H,		#00H ;按键次数
	  MOV  R1,		#24H ;指针，访问BCD码
	  MOV  R0,		#26H
	  MOV  R3,		#11111110B;位码初值
	  ACALL		TRAIN
	 HERE: SJMP HERE  ;原地等待中断

TRAIN:

	 MOV  	IE,		#9BH
	 MOV		A,		@R0
	 MOV		SBUF,		A
	
	 
T1_INT:
	 RETI

COM_INT:
	 CLR		TI
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA	
	 
	 INC		R0
	 CJNE		R0,		#2AH,		SEND
	 CLR		ES
	 MOV		R0,		#26H
NEXT:  CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
	 
SEND:	 MOV		A,		@R0
	 MOV		SBUF,		A	
	 JMP		NEXT
	 


T0_INT:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc	 	 
	 SETB 	EA
	 MOV  	TL0,		#018H
	 MOV  	TH0,		#0FCH 
	 
	 MOV   	P0,		@R1   ;显示程序，@R1为段码输出到P0
       SETB  	LATCH1
       CLR   	LATCH1
       MOV   	P0,		R3	;输出位码
       SETB  	LATCH2
       CLR   	LATCH2
	 DEC   	R1
	 MOV   	A,		R3
	 RL    	A
	 MOV   	R3,		A
	 CJNE  	R1,		#1CH,		EXIT_SCAN
	 MOV   	R1,		#24H		 
EXIT_SCAN: 
	 MOV		A,		32H          ;按键计数值，选功能
	 CJNE 	A,		#01H ,EQU2	 ;按键值为1，计数，并转为换段码
	 SETB 	TR0
	 INC  	25H
	 MOV  	A,		25H
	 CJNE 	A,		#0AH, EXIT_T0_INT		;10ms进一次TIME & STORE
	 MOV  	25H,		#00H
	 MOV  	30H,		R0
	 MOV  	31H,		R1		;假装	R0,	R1入栈
	 MOV 		R1,		#26H 		;指针，访问BCD码
	 MOV 		R0,		#1DH 		;指针，存段码
       CALL 	TIME
	 CALL 	STORE
	 MOV 		R0,		#26H
	 SETB		ES
	 MOV		SBUF,		@R0	;串口发送新数据	
	 MOV 		R1,		31H
	 MOV		R0,		30H	;假装出栈
	 
	 MOV		A,		@R0
	 MOV		SBUF,		A
	 SJMP 	EXIT_T0_INT
EQU2:  CJNE 	A,	#02H,	EQU3		 ;按键值为2，跳过计数过程，实现暂停
	 SJMP 	EXIT_T0_INT
EQU3:	
	 MOV  	30H,		R0
	 MOV  	31H,		R1		;假装R1入栈
	 MOV 		R1,		#26H 		;指针，访问BCD码
	 MOV 		R0,		#1DH 		;指针，存段码
	 MOV 		25H,		#00H	
	 MOV 		26H,		#00H	 	;按键值为3，清零
	 MOV 		27H,		#00H
	 MOV 		28H,		#00H
	 MOV 		29H,		#00H
	 CALL STORE
	 MOV 		R0,		#26H
	 MOV		SBUF,		@R0
	 MOV 		R1,		31H		;假装出栈
	 MOV		R0,		30H
EXIT_T0_INT:
	 CLR EA
	 POP 		Acc
	 POP 		PSW
	 SETB		EA
	 RETI

;TIME为毫秒，秒，分，时
TIME:   
	  INC  	26H
	  MOV  	A,		26H
	  CJNE 	A,		#64H, EXIT_TIME
	  MOV  	26H,		#00H
	  
	  INC  	27H
	  MOV  	A,		27H
	  CJNE 	A,		#3CH, EXIT_TIME	  
	  MOV  	27H,		#00H
	  
	  INC  	28H
	  MOV  	A,		28H
	  CJNE 	A,		#3CH, EXIT_TIME	  
	  MOV  	28H,		#00H
	  
	  INC  	29H
	  MOV  	A,		29H
	  CJNE 	A,		#18H, EXIT_TIME
	  MOV  	29H,		#00H
	  EXIT_TIME:  RET
	  
;STORE为毫秒，秒，分，时	的段码	 
STORE:
	  MOV 	A,		@R1
	  MOV 	B,		#10
	  DIV 	AB
	  MOVC 	A,		@A+DPTR
	  INC 	R0
	  MOV 	@R0,		A
	  MOV 	A,B
	  MOVC	A,		@A+DPTR
	  DEC 	R0
	  MOV 	@R0,		A
	  INC 	R0
	  INC 	R0
	  INC 	R1
	  CJNE 	R1,		#2AH,	STORE	  
	  RET

INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA	
	 INC 		32H		;按键中断计数
	 MOV 		A,		32H
	 CJNE		A,		#04H,	NEXT0
	 MOV 		32H,		#01H	     
NEXT0: CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
 
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;共阴字码表
END