;Ahmet Enes �igdem
;150220079

W_CAPACITY EQU 50    ; Define a constant for maximum weight capacity
SIZE       EQU 3     ; Define a constant for the size of the items array

	AREA QUESTION_2, CODE, READONLY
	ENTRY 
	ALIGN
		
__main FUNCTION 
	EXPORT __main
	LDR R0, =W_CAPACITY; R0 = W_capacity
	LDR R1, =SIZE; R1 = SIZE 
	PUSH {R0, R1}; prepare to run knapSnack
	
	BL knapSack; go to knapSack
	;Return value will be writen to R0
	
	LDR R1, =profit
	LDR R2, =weight; Put them to right register for sake of question
	LDR R3, =dp
	B stop
	
stop 
	B stop
	
knapSack FUNCTION
	POP {R1, R0}; R0 = W, R1 = n they are already have the value but sake of the function I poped them.
	PUSH {LR}; write the return position of the function to stack
	MOVS R2, #1 ; holds i
	LDR R5, =dp; Hold the dp pointer
	
	
Loop1 
	ADDS R4, R1, #1; R4 = n + 1
	MOVS R3, R0 ; initilaize R3 = w before go into Loop2
	CMP R4, R2; check i < n + 1
	BGT Loop2; if i < n + 1 go to loop
	B endLoop1; else go end of the loop
	
Loop2
	MOVS R4, #0; R4 = 0 for the comparision
	CMP R3, R4; check if w >= 0
	BLT endLoop2; if w < 0 go to end of the loop
	
	SUBS R4, R2, #1;right index of weight i - 1
	LSLS R4, R4, #2; multiply R4 by 4 to get the right offset
	LDR R6, =weight; Hold the weight pointer
	LDR R4, [R6, R4]; R4 = weight[i - 1]
	
	CMP R4, R3; check weight[i - 1] <= w
	BLE goif; go inside the if block
	B ifContinuous; continue of if block
	
goif
	MOVS R4, R3; R4 = w to get the right index of dp[w]
	LSLS R4, R4, #2; multiply R4 to get the right offset
	LDR R5, =dp; Hold the dp pointer
	LDR R4, [R5, R4]; R4 = dp[w]
	
	PUSH {R4}; push it to stack to use it in max function
	
	SUBS R4, R2, #1;right index of weight i - 1
	LSLS R4, R4, #2; multiply R4 by 4 to get the right offset
	LDR R6, =weight; Hold the weight pointer
	LDR R4, [R6, R4]; R4 = weight[i - 1]
	
	SUBS R4, R3, R4; R4 = w - weight[i - 1]
	LSLS R4, R4 ,#2;get the right index
	LDR R5, =dp; Hold the dp pointer
	LDR R4, [R5, R4]; R4 = dp[w - weight[i - 1]]
	
	MOVS R6, R2; R6 = i
	SUBS R6, #1; R6 = i - 1
	LSLS R6, R6, #2; get the right index
	LDR R7, =profit; Hold the weight pointer
	LDR R6, [R7, R6]; R6 = profit[i - 1]
	
	ADDS R4, R6; R4 = dp[w - weight[i - 1]] + profit[i - 1]
	
	PUSH {R4}; push it to stackt to use it in max function
	BL max_value
	POP {R4}; get the return of max_value to R4
 	LSLS R3, R3, #2; get the rigth index of dp
	LDR R5, =dp; Hold the dp pointer
	
	STR R4, [R5, R3]; dp[w] = return of max_value
	LSRS R3, R3, #2; make it show w again 
	
ifContinuous
	SUBS R3, #1; w--
	B Loop2; loop back to for
	
endLoop2
	ADDS R2, #1; i++
	B Loop1; loop back to for
	
endLoop1
	LSLS R0, R0, #2; to have the right index W
	;SUBS R0, #4; to have the W - 1
	LDR R5, =dp; Hold the dp pointer
	LDR R0, [R5, R0]; R0 = dp[W] return of function
	POP{PC}; PC = LR
	

max_value FUNCTION
	POP {R7, R6}; get the variable of the functions
	CMP R6, R7; a > b ? 
	BGT endA; if a > b go endA
	B endB; else go endB
endA 
	PUSH {R6}; return a
	BX LR; out of function
endB 
	PUSH {R7}; return b 
	BX LR; out of funciont


	AREA Quesiton_Data, DATA, READONLY
	ALIGN

profit DCD 60, 100, 120; profit array initialization
endProfit

weight DCD 10, 20, 30; weight array initialization
endWeight

	AREA dpArray, DATA, READWRITE
	ALIGN
		
dp SPACE (W_CAPACITY + 1) * 4; dp memory alocation W_capacity + 1
endDp
END