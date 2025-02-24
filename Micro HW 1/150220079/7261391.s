;Ahmet Enes Çigdem
;150220079

W_CAPACITY EQU 80  ; Define a constant for maximum weight capacity
SIZE       EQU 6   ; Define a constant for the size of the items array

	AREA QUESTION_1, CODE, READONLY
	ENTRY 
	ALIGN
		
__main FUNCTION 
	EXPORT __main	
		
	LDR R0, =W_CAPACITY; R0 = W_CAPACITY
	LDR R1, =SIZE; R1 =SIZE
	PUSH {R0, R1}; Hold variable in the stack for knapSackFunction
	
	BL knapSack; start knapSack
	; return values will be written to R0
	
	LDR R1, =profit;
	LDR R2, =weight;
	
stop
	B stop
	

knapSack FUNCTION
	
	POP{R0}; R1 = n, 
	POP{R1}; R0 = W
	PUSH {LR}; Save the return address
	;MOVS R6, #0; global return holder
	
;CHECK FOR n == 0 W == 0
	
	MOVS R2, #0; make r2 0 for comparision
	CMP R2, R1; check W value
	BEQ return0; return 0
	
	CMP R2, R0; check n value
	BEQ return0; return 0
	
	B ifcontinue
	
return0

	MOVS R0, R2; return value writen to R0 = 0
	POP{PC}; return back to position
	
; CONTINUE FROM CHECK
ifcontinue

	MOVS R2, R1; R2 = n
	SUBS R2, #1; R2 = n - 1
	LDR R3, =weight; get the weight array
	LSLS R2, R2, #2; Multiply R2 by 4 for indexing
	LDR R2, [R3, R2]; R2 = weight[n - 1]
	
; SECOND IF BLOCK CHECK
	CMP R2, R0; check fpr weght[n - 1] > W
	BGT returnKnapSack
	B returnMax
	
returnKnapSack
	
	PUSH{R0, R1, R2, R3, R4, R6}; push them stack to protect them
	MOVS R6, #0; make it 0 to knapSack use it
	
	SUBS R1, #1; R1 = n - 1
	PUSH {R1}; Push n - 1 to stack for knapSack(W, n - 1) function return
	PUSH {R0}; Push W to stack for knapSack(W, n - 1) function return
	
	BL knapSack; Return knapSack(W, n - 1)
	;return value will be writen to R0
	MOVS R7, R0; get the return value of knapsack
	
	POP{R6, R4, R3, R2, R1, R0}; get back the values;
	ADDS R6, R7; Add the return value to R6
	MOVS R7, #0; Clean R7 to use it in different recursion
	POP{PC}; get out of the function

	
	
returnMax

	
;Return max(knapSack(W, n - 1), profit[n - 1] + knapSack(W - weight[n - 1], n - 1)
	
	;First lets get knapSack(W, n - 1)
	
	PUSH{R0, R1, R2, R3, R4, R6}; push them stack to protect them
	MOVS R6, #0; R6 = 0 to protect the recursion
	
	
	SUBS R1, #1; R1 = n - 1
	PUSH {R1}; Push n - 1 to stack for knapSack(W, n - 1) function return
	PUSH {R0}; Push W to stack for knapSack(W, n - 1)
	BL knapSack; Return knapSack(W, n - 1)
	;return value will be written to R0
	MOVS R7, R0; get the return value of knapsack;
	
	POP{R6, R4, R3, R2, R1, R0}; get back the values
	ADDS R7, R6; Adds R6 to R7 store return value 
	PUSH {R7}; Save R7 in the stack for max function
	MOVS R7, #0; Clean R7 to use it next
	
	
	; knapSack(W - weight[n - 1], n - 1)
	
	PUSH{R0, R1, R2, R3, R4, R6}; push them stack to protect them
	MOVS R6, #0;
	SUBS R1, #1; R1 = n - 1
	LDR R5, =weight; R5 holds weight pointer
	LSLS R1, R1, #2; multiply n - 1 to get the right index of weight[n - 1]
	LDR R5, [R5, R1]; R5 = weight[n - 1]
	SUBS R5, R0, R5; R5 = W - weight[n - 1]
	LSRS R1, R1, #2; to reproduce n - 1 from R1
	PUSH {R1}; second input of knapSack(W - weight[n - 1], n - 1)
	PUSH{R5}; first input of knapSack(W - weight[n - 1], n - 1)
	
	BL knapSack; start knapSack(W - weight[n - 1], n - 1)
	;return value will be written to R0
	
	MOVS R7, R0; R7 = knapSack(W - weight[n - 1], n - 1)
	POP{R6, R4, R3, R2, R1, R0}; get back the values;
	ADDS R7, R6; write knapSack(W - weight[n - 1], n - 1) for general to R7
	
	; Profit[n - 1]
	
	LDR R3, =profit; R3 holds profit pointer
	SUBS R4, R1, #1; R4 = n - 1
	LSLS R4, R4, #2; multiply n - 1 to get the right index of profit[n - 1]
	LDR R3, [R3, R4]; R3 = profit[n - 1]
	ADDS R7, R3; R7 = profit[n - 1] + knapSack(W - weight[n - 1], n - 1)
	PUSH {R7}; Push it for Max Function
	
	;max function
	BL max_value
	POP{R0}; take return of max function to R0
	POP{PC}; get out of the function
	
	
max_value FUNCTION
	POP {R0, R1}; get the variable of the functions
	CMP R0, R1; a > b ? 
	BGT endA; if a > b go endA
	B endB; else go endB
endA 
	PUSH {R0}; return a
	BX LR; out of function
endB 
	PUSH {R1}; return b 
	BX LR; out of funciont
	
	
profit DCD 206, 133, 154, 243, 139, 115; profit array initialization
endProfit

weight DCD 7, 18, 25, 33, 45, 12; weight array initialization
endWeight

	
END