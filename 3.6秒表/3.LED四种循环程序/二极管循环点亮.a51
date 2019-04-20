
;定时器中断流水灯
;编写人：高洪伟
;编写日期2019-4-6
;修改日期2019-4-10
;50ms次数，满20清零

LATCH1 BIT P2.2
LATCH2 BIT P2.3
NEWFLAG	BIT	7FH
ORG 0000H
LJMP START
ORG 0003H
LJMP INT_0
ORG 000BH
LJMP T_0
START:	SETB 	 	EA
	SETB		EX0
	SETB 		PX0
	SETB 		IT0		
	MOV		TMOD,		#01H		;T0中断初始化
	MOV		TCON,		#13H
	MOV		IE,		#83H
	MOV		TL0,		#0B0H		;定时50ms
	MOV		TH0,		#3CH		;按一次溢出一次
      MOV 		SP,		#60H		;分配堆栈
	MOV		30H,		#00H		;50ms次数，满20清零
	MOV		31H,		#00H		;控制移位间隔时间
	MOV		R0,		#0FEH
	CLR		NEWFLAG	
HERE:
	MOV	 	P1,	 	R0
	
DELAY:JNB	 	NEWFLAG,	DELAY
	CLR	 	NEWFLAG
	MOV	 	31H,		#00H
	MOV		A,	 	R0
	RL	 	A
	MOV	 	R0,		A
	SJMP	 	HERE



T_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
	 MOV		TL0,		#0B0H
	 MOV		TH0,		#3CH		
	 
	 MOV		A,		30H
	 CJNE		A,		#01H,		ONE
	 CJNE		A,		#02H,		TWO
	 CJNE		A,		#03H,		THREE
	 CJNE		A,		#04H,		EXIT
	 MOV		30H,		#00H      
 EXIT:	
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
	 
INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
	 INC		30H
	 CPL		P3.7
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI	 
	 
ONE:	 SETB		NEWFLAG
	 RET
	 
TWO:	 INC		31H
	 MOV		R1,		31H
	 CJNE		R1,		#05H,		EXIT
	 SETB		NEWFLAG
	 RET

THREE: INC		31H
	 MOV		R1,		31H
	 CJNE		R1,		#0AH,		EXIT
	 SETB		NEWFLAG
	 RET

FOUR:  INC		31H
	 MOV		R1,		31H
	 CJNE		R1,		#0FH,		EXIT
	 SETB		NEWFLAG
	 RET

END