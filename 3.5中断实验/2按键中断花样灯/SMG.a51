;按键中断 花样灯 6种模式
;编写人：高洪伟
;编写日期2019-4-6
;修改日期2019-4-10
;30H为按键计数存储单元
LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START
ORG 0003H
LJMP INT_0
START:
	SETB 	 	EA
	SETB		EX0
	SETB 		PX0
	SETB 		IT0				;INT0中断初始化
      MOV 		DPTR,		#TABLE
      MOV 		SP,		#60H		;分配堆栈
      MOV 		R1,		#00H		;按键计数存储单元

SCAN:	      
     SJMP 		SCAN

INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA   
	 
	 MOV		A,		R1
	 MOVC		A,		@A+DPTR
	 MOV		P1,		A
	 INC		R1
	 CJNE		R1,		#06H,		EXIT
	 MOV		R1,		#00H
 EXIT: CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
	  
TABLE:DB 0AAH,055H,0F0H,0FH,99H,66H   ;LED表
END