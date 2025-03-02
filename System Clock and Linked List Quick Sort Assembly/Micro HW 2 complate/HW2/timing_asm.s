        AREA    Timing_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  Systick_Start_asm
        EXPORT  Systick_Stop_asm
		EXPORT	SysTick_Handler ; When the correct time comes,
									; remove this from the comments.
		EXTERN	ticks

SysTick_Handler FUNCTION
		PUSH	{LR}
		;PUSH 	{R0, R1}
		; You should only increment ticks here.
		LDR R1, =ticks;
		LDR R0, [R1];
		ADDS R0, #1;
		STR R0, [R1];
		;POP		{R0, R1}
		POP		{PC}
		ENDFUNC

Systick_Start_asm FUNCTION
		PUSH	{LR}
		;PUSH 	{R0, R1, R2, R3}
		
		LDR R1, =ticks
		MOVS R2, #0
		STR R2, [R1]; ticks = 0;
		
		LDR R0, =0xE000E018; R0 = CURRENT VALUE ADDRESS
		LDR R1, =0xE000E014; R1 = RELOAD VALUE ADDRESS
		
		
		MOVS R3, #0; R3 = 0;
		STR R3, [R0]; CURRENT VALUE = 0;
		
		LDR R3, =0x000000F9; R3 = 249
		STR R3, [R1]; RELAOD VALUE = 249
		
		LDR R2, =0xE000E010; R2 = CONTROL REGISTER ADDRESS
		LDR R3, =0x00010007;
		STR R3, [R2]; CONTROL REGISTER ENABLE SET
		;POP 	{R0, R1, R2, R3}
        POP		{PC}
		ENDFUNC

Systick_Stop_asm FUNCTION
		PUSH	{LR}
		;PUSH 	{R1, R2, R3}
		; You should stop SysTick, zero the ticks,
			; and return "non-zero value of ticks".
		LDR R2, =0xE000E010; R2 = CONTROL REGISTER ADDRESS
		LDR R3, =0xFFFFFFFE;
		STR R3, [R2]; CONTROL REGISETR ENABLE CLOSED
		
		LDR R1, =ticks
		LDR R0, [R1]; R0 = ticks
		MOVS R2, #0
		STR R2, [R1]; ticks = 0;
		
		;POP 	{R1, R2, R3}
		POP		{PC}
		ENDFUNC

		END
