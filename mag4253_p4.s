.global main
.func main
   
main:

BL  _scanf
MOV R4, R0
BL  _scanf
MOV R6, R0
MOV R0, R4
MOV R1, R6
BL  _printf
BL _divide
BL  _printf_result      @ print the result
B main
    

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return

_divide:
PUSH {LR}

VMOV S0, R0             @ move the numerator to floating point register
VMOV S1, R1             @ move the denominator to floating point register
VCVT.F32.S32 S0, S0     @ convert unsigned bit representation to single float
VCVT.F32.S32 S1, S1     @ convert unsigned bit representation to single float

VDIV.F32 S2, S0, S1     @ compute S2 = S0 * S1

VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
VMOV R1, R2, D4         @ split the double VFP register into two ARM registers

POP {PC}                @ pop LR from stack and return

_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #31             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_printf:
MOV R4, LR              @ store LR since printf call overwrites
LDR R0, =printf_str     @ R0 contains formatted string address
MOV R1, R1              @ R1 contains printf argument (redundant line)
BL printf               @ call printf
MOV PC, R4              @ return

_scanf:
PUSH {LR}                @ store LR since scanf call overwrites
SUB SP, SP, #4          @ make room on stack
LDR R0, =format_str     @ R0 contains address of format string
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ restore the stack pointer
POP {PC}                 @ return

.data
format_str:     .asciz      "%d\n"
format_str:     .asciz      "%d/%d
printf_str      .asciz      "=%f\n"
