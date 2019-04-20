;定时器中断使P1.0反转程序
;编写人：高洪伟
;编写日期2019-4-6
;修改日期2019-4-10
;50ms次数，满20清零

LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START
ORG 000BH
LJMP T_0
START:
	MOV		TMOD,		#01H		;T0中断初始化
	MOV		TCON,		#11H
	MOV		IE,		#82H
	MOV		TL0,		#0B0H		;定时50ms
	MOV		TH0,		#3CH		;按一次溢出一次
      MOV 		SP,		#60H		;分配堆栈
	MOV		30H,		#00H		;50ms次数，满20清零
	
SCAN:	JMP SCAN

T_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
	 MOV		TL0,		#0B0H
	 MOV		TH0,		#3CH		
	 INC		30H
	 MOV		A,		30H
	 CJNE		A,		#14H,		EXIT
	 MOV		30H,		#00H
       CPL		P1.0
 EXIT:	
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
END