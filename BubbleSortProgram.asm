.ORIG x3000
LEA R0, UnsortedData
TRAP x22
JSR OutputData ; Subroutine for outputting data
RESTART 
ADD R4, R4, #-1 ;The number of value in the list is held in R4, placed by the ;subroutine OutputData, this holds how many times the program should loop. 
BRz EndSort ;checks how many times the loop has executed
LD R6, DataPointer ; In the main sort R6 is the N value
LD R5, DataPointer ; and R5 is the N+1 or the next value in the list
ADD R5, R5, #1      ; this is achieved by adding 1 to the value of the pointer

;The main sort algorithm
 
LOOP 
LDR R1, R6, #0 ;R1 will hold the N value
LDR R2, R5, #0 ;R2 will hold the N+1 value, i.e. the next value in the list
ADD R2, R2, #0 ;If R2 is 0 then the end of the loop has been reached
BRz RESTART  ; the sort will restart
ADD R1, R1, #0 
BRn CheckNext ;if the value held in R1 is neg it branches to a different sort
ADD R2, R2, #0 ; if R2 is negative and R1 positive the value are swapped  ;automatically
BRn SwapValues

;If both R1 and R2 are positive they are compared and swapped if necessary

NOT R3, R2		;R2 is changed to it negative value and loaded to R3
ADD R3, R3, #1		;if the result of adding R3 and R1 is positive they are 
ADD R3, R1, R3		;they are swapped and if it is negative or zero
BRp SwapValues		;they not swapped
BRnz DoNothing

SwapValues STR R2, R6, #0  ;the values are swapped by the value in R2 
STR R1, R5, #0			;saved to the R6 pointer location and R1 at R5
ADD R5, R5, #1			;both pointers are incremented to the next 
ADD R6, R6, #1			;values in the list 
BRnzp LOOP			


CheckNext 			;this branch is taken if the N value, R1, is negative 
ADD R2, R2, #0		;if R2 is also negative then they are sorted at BothNegative
BRn BothNegative		
BRp DoNothing		;if R2 is positive the program does nothing and moves
BRz RESTART		;to the next in the list or restarts 

BothNegative		;if both N or R1, and N+1 or R2 are negative values
NOT R0, R2			;like the previous sort N+1’s sign is changed and compared
ADD R0, R0, #1		
ADD R0, R1, R0		;if the result is positive then |N+1| > |N| and they are swapped
BRp SwapValues


;This does not change the list and both pointers are incremented
DoNothing  			
ADD R5, R5, #1		
ADD R6, R6, #1
BRnzp LOOP

;When the end sort is reached, the program uses OutputData to print the sorted list to the ;console and after returning the program ends
EndSort
LEA R0, Sorted
TRAP x22
JSR OutputData
BRnzp EndProgram



;output data subroutine
OutputData
ST R0, Save_0	;saving the registers used by the subroutine 
ST R1, Save_1
ST R7, Save_7
ST R2, Save_2
ST R3, Save_3
LD R0, NewLine 		;A newline is printed for clarity
TRAP x21
AND R4, R4, #0		;R4 is used to count the number of values
LD R1, DataPointer 		;This is a pointer for the list
LD R2, ASCIIBuff		;The ASCII value x0A is used to change from numerical 
OutputLoop			;values to ASCII in order to print to the screen 
LDR R0, R1, #0		;R0 holds the value of the list
ADD R0, R0, #0
BRz Return			;If the value is 0, the end of the list has been reached
BRn NegNum		;If the value is negative it is output with a (-) sign
BRp PosNum			;If the value is positive it is output with a (+) sign 

PosNum
LD R0, ASCIIPlus		;The (+) is output before the number
TRAP x21
LDR R0, R1, #0		
ADD R0, R0, R2		;The number is added to the ASCIIBuff to output the ASCII 
TRAP x21			;representation of the number
LD R0, Space		;A space is output to make the list more clear
TRAP x21
ADD R1, R1, #1		;The pointer to the next value is incremented
ADD R4, R4, #1
BRnzp OutputLoop  

NegNum			;If the value being output is negative, a (-) precedes the value
LD R0, ASCIIMinus	;ASCIIMinus is the ascii value for (-)
TRAP x21
LDR R0, R1, #0		;Before the value can be output it is changed to its positive 
NOT R0, R0			;value and the ASCIIBuff is added to output the ASCII 
ADD R0, R0, #1		;representation
ADD R0, R0, R2		
TRAP x21
LD R0, Space		;A space between numbers is added for clarity
TRAP x21
ADD R1, R1, #1		;The pointer to the next value is incremented and returns
ADD R4, R4, #1		;to the beginning of the loop. 
BRnzp OutputLoop


;After all the values are output a newline is output for clarity and registers 0,1,2,3, and 7 ;are restored

Return 
LD R0, NewLine
TRAP x21
LD R0, Save_0
LD R1, Save_1
LD R7, Save_7
LD R2, Save_2
LD R3, Save_3
RET

EndProgram 
HALT
Sorted              .STRINGZ "This is the sorted data: "
UnsortedData        .STRINGZ "This is the unsorted data: "
ASCIIMinus	.FILL x2D			;ASCII of (-)
ASCIIPlus		.FILL x2B		;ASCII of (+)
DataPointer         .FILL    x4000		;pointer to the list data of BubbleSortData
NewLine             .FILL    x0A		;ASCII newline character
Space			.FILL    x20		;ASCII for a space between characters
ASCIIBuff           .FILL    x30		
Save_2              .BLKW    #1
Save_0              .BLKW    #1
Save_1              .BLKW    #1
Save_7              .BLKW    #1
Save_3 	       .BLKW   #1

.END

