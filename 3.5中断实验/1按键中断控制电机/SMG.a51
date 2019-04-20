;按键中断P1.0取反控制电机程序
;编写人：高洪伟
;编写日期2019-4-6
;修改日期2019-4-10
;30H为按键计数存储单元
;

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
   
      MOV 		SP,		#60H		;分配堆栈
      MOV 		30H,		#00H		;按键计数存储单元

SCAN:	   
        LJMP 		SCAN


INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA       
	 CPL		P1.0	
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI

END