;按键中断程序
;编写人：高洪伟
;编写日期2019-4-6
;修改日期2019-4-10
;30H为定时器按键计数存储单元
;

LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START
ORG 000BH
LJMP T_0
START:
	MOV		TMOD,		#05H		;T0中断初始化
	MOV		TCON,		#11H
	MOV		IE,		#82H
	MOV		TL0,		#0FFH
	MOV		TH0,		#0FFH		;按一次溢出一次
      MOV 		DPTR,		#TABLE
      MOV 		SP,		#60H		;分配堆栈
      MOV 		30H,		#00H		;按键计数存储单元
	CALL 		STORE				;先存储一次段码

SCAN:	
     MOV		A,		30H
     XRL		A,		#0FFH
     MOV		P1,		A

     MOV 		A,		22H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111110B 
     SETB 		LATCH2	
     CLR 		LATCH2
     CALL 		DELAY

     MOV 		A,		21H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111101B 
     SETB 		LATCH2
     CLR 		LATCH2
     CALL 		DELAY
	 
     MOV 		A,		20H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111011B
     SETB 		LATCH2
     CLR 		LATCH2
     CALL 		DELAY
     LJMP 		SCAN

DELAY: MOV 		R6,		#4    ;扫描延时
D3:    MOV 		R7,		#248
       DJNZ 	R7,		$
       DJNZ 	R6,		D3
       RET
T_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
	 MOV		TL0,		#0FFH
	 MOV		TH0,		#0FFH
       INC 		30H			;按键次数
	 CALL 	STORE 		;转换为段码
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI

;段码转换程序
STORE:
	  MOV 	A,	30H
	  MOV 	B,	#100
	  DIV 	AB
	  MOVC 	A,	@A+DPTR
	  MOV 	22H,	A
	  MOV 	A,	B
	  MOV 	B,	#10
	  DIV 	AB
	  MOVC 	A,	@A+DPTR
	  MOV 	21H,	A
	  MOV 	A,	B
	  MOVC 	A,	@A+DPTR
	  MOV 	20H,A
	  RET
	  
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;共阴字码表
END