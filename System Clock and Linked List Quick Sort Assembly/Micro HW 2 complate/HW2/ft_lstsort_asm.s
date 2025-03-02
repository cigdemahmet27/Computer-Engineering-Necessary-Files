; Function: ft_lstsort_asm
; Parameters:
;   R0 - Pointer to the list (address of t_list *)
;   R1 - Pointer to comparison function (address of int (*f_comp)(int, int))
        AREA    Sorting_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  ft_lstsort_asm
		EXTERN	ft_lstsize
			
ft_lstsort_asm FUNCTION
		PUSH	{R0-R1, LR}
		;BL ft_lstsize; R0 = size of the list
		LDR R0, [SP]; R0 = head
		LDR R0, [R0]; R0 = *head
		SUB SP, #4; intialize k;
		BL ft_lstsize; R0 = ft_lstsize
		SUBS R0, #1; R0 = ft_lstsize - 1
		STR R0, [SP]; k = ft_lstsize - 1
		
		

		;LOOP 1 INITALIZATION
		MOVS R0, #0;
		SUB SP, #4; int i
		STR R0, [SP]; int i = 0;
Loop1	
		;LDR R0, [SP, #4]; R0 = head;
		;LDR R0, [R0]; R0 = *head
		;BL ft_lstsize; R0 = ft_lstsize
		;SUBS R0, #1; R0 = ft_lstsize - 1
		;LDR R1, [SP]; R1 = i
		
		LDR R0, [SP, #4]; R0 = k
		LDR R1, [SP]; R1 = i
		CMP R1, R0
		BGE Loop1END
		
		;LOOP 1 EXECUTION
		SUB SP, #4; Node* curr;
		LDR R0, [SP, #12]; R0 = head
		LDR R0, [R0]; R0 = *head;
		STR R0, [SP]; curr = *head;
		SUB SP, #4; Node* prev;
		MOVS R0, #0;
		STR R0, [SP]; prev = NULL
		
		;LOOP 2 INITALIZATION
		SUB SP, #4; int j
		MOVS R0, #0;
		STR R0, [SP]; j = 0;
Loop2
		;LDR R0, [SP, #16]; R0 = head;
		;LDR R0, [R0]; R0 = *head
		;BL ft_lstsize; R0 = ft_lstsize
		;SUBS R0, #1; R0 = ft_lstsize - 1;
		LDR R0, [SP, #16]; R0 = k
		LDR R1, [SP, #12]; R1 = i
		SUBS R0, R1; R0 = k - i
		LDR R1, [SP]; R1 = j
		
		CMP R1, R0
		BGE Loop2END
		
		;LOOP 2 EXECUTION
		
		; IF !CURR || !CURR->NEXT
		LDR R0, [SP, #8]; R0 = curr
		CMP R0, #0
		BEQ Loop2END
		LDR R0, [R0, #4]; R0 = curr->next
		CMP R0, #0
		BEQ	Loop2END
		
		; IF curr->data > curr->next->data
		
		LDR R1, [SP, #8]; R1 = curr
		LDR R1, [R1]; R1 = curr->data
		
		LDR R0,	[SP, #8]; R0 = curr
		LDR R0, [R0, #4]; R0 = curr->next
		LDR R0, [R0]; R0 = curr->next->data
		
		LDR R2, [SP, #24]; R2 = compare function pointer
		
		PUSH {R0, R1, R2, R3}
		BLX R2; compare function call result in R0

if1
		CMP R0, #0
		POP {R0, R1, R2, R3}
		BEQ else1
		;IF 1 EXECUTION
		SUB SP, #4; Node* tmp;
		LDR R0, [SP, #12]; R0 = curr;
		LDR R0, [R0, #4]; R0 = curr->next;
		STR R0, [SP]; tmp = curr->next;
		
		LDR R0, [SP, #12]; R0 = curr
		LDR R1, [SP, #24]; R1 = head;
		LDR R1, [R1]; R1 = *head;
if2	
		CMP R0, R1
		BNE else2
		;IF 2 EXECUTION
		
		LDR R0, [SP, #24]; R0 = head;
		LDR R1, [SP]; R1 = tmp
		STR R1, [R0]; *head = tmp
		B if2END
		
else2
		LDR R0, [SP, #8]; R0 = prev
		LDR R1, [SP]; R1 = tmp
		STR R1, [R0, #4]; prev->next = tmp
if2END
		
		LDR R0, [SP, #12]; R0 = curr
		LDR R1, [SP]; R1 = tmp
		LDR R1, [R1, #4]; R1 = tmp->next
		STR R1, [R0, #4]; curr->next = tmp->next
		
		LDR R0, [SP, #12]; R0 = curr
		LDR R1, [SP]; R1 = tmp
		STR R0, [R1, #4]; tmp->next = curr;
		
		LDR R0, [SP]; R0 = tmp
		STR R0, [SP, #8]; prev = tmp
		ADD SP, #4; destroy tmp
		B if1END
		
else1	
		LDR R0, [SP, #8]; R0 = curr
		STR R0, [SP, #4]; prev = curr;
		
		;LDR R0, [SP, #8]; R0 = curr
		LDR R0, [R0, #4]; R0 = curr->next
		STR R0, [SP, #8]; curr = curr->next
if1END
		LDR R0, [SP]; R0 = j
		ADDS R0, #1; R0 = j + 1
		STR R0, [SP]; j = j + 1
		B Loop2
	
Loop2END
		;ADD SP, #4; destroy j
		
		LDR R0, [SP, #12]; R0 = i
		ADDS R0, #1; R0 = i + 1
		STR R0, [SP, #12]; i = i + 1
		ADD SP, #12; destroy prev curr j
		B Loop1
Loop1END
		ADD SP, #8;destroy i, k
		
		POP		{R0-R1, PC}
		ENDFUNC
