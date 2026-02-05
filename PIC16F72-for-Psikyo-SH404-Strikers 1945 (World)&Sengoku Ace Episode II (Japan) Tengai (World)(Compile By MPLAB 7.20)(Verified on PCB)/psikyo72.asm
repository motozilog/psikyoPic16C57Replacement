; PIC16F72 Ported Assembly Program (Final Fixed Version)
; Constraint: PortA(RA0~RA3) / PortB(RB0~RB7) / PortC(RC0~RC7) (Hardware PortC)
; Configuration: HS Oscillator / WDT Disabled / Code Protect Disabled
; Register Address & Bit Definition (PIC16F72 Bank0)
STATUS      EQU 03h        ; Status Register (Bank0: 03h)
PCL         EQU 02h        ; Program Counter Low Byte (Bank0: 02h)
FSR         EQU 04h        ; File Select Register (Bank0: 04h)
PORTA       EQU 05h        ; PortA Data Register (Bank0: 05h, RA0~RA3 used)
PORTB       EQU 06h        ; PortB Data Register (Bank0: 06h, Full 8bit)
PORTC       EQU 07h        ; PortC Data Register (Bank0: 07h, F72 Hardware PortC)
Reg10       EQU 20h        ; User Register 10h (Bank0: 10h)
Reg11       EQU 21h        ; User Register 11h (Bank0: 11h)
Reg12       EQU 22h        ; User Register 12h (Bank0: 12h)
Reg13       EQU 23h        ; User Register 13h (Bank0: 13h)
Reg14       EQU 24h        ; User Register 14h (Bank0: 14h)
; 以下是新增的A/D相关寄存器及位定义
ADCON0      EQU 1Fh        ; A/D控制寄存器（Bank0，固定地址1Fh）
ADCON1      EQU 9Fh        ; A/D配置寄存器（Bank1，固定地址8Eh）
; STATUS Register Bit Definition (Fix RP0/RP1 Undefined)
RP0         EQU 5          ; STATUS Bit5 = RP0 (Bank Select)
RP1         EQU 6          ; STATUS Bit6 = RP1 (Bank Select)
TRISA       EQU 85h        ; PORTA方向寄存器（Bank1，85h）
TRISB       EQU 86h        ; PORTB方向寄存器（Bank1，86h）
TRISC       EQU 87h        ; PORTC方向寄存器（Bank1，87h）

; Configuration Word (16进制直接定义，适配所有汇编器)
; CONFIG1 (0x2007): HS Osc / WDT Off / PWRTE On / CP Off
 __CONFIG 0x3FFA  ; 等价于 0x37FB（HS+WDT Off+CP Off）

; Reset Vector (PIC16F72: 0x000)
ORG 0x000
	GOTO MAIN                  ; Reset Jump to Main Program

; Table Entry (Moved to 0x004 - Avoid Interrupt Vector)
ORG 0x004
	TABLE_ENTRY:
    ADDWF PCL,F            ; Table Address Calculation Logic

; Data Table (0x005~0x030: Original RETLW Sequence)
ORG 0x005
    RETLW 00h          ; 0x005 (Original 0x001)
    RETLW 00h          ; 0x006 (Original 0x002)
    RETLW 64h          ; 0x007 (Original 0x003)
    RETLW 0AEh         ; 0x008 (Original 0x004)
    RETLW 00h          ; 0x009 (Original 0x005)
    RETLW 00h          ; 0x00A (Original 0x006)
    RETLW 26h          ; 0x00B (Original 0x007)
    RETLW 2Ch          ; 0x00C (Original 0x008)
    RETLW 00h          ; 0x00D (Original 0x009)
    RETLW 00h          ; 0x00E (Original 0x00A)
    RETLW 2Ch          ; 0x00F (Original 0x00B)
    RETLW 0DAh         ; 0x010 (Original 0x00C)
    RETLW 00h          ; 0x011 (Original 0x00D)
    RETLW 00h          ; 0x012 (Original 0x00E)
    RETLW 2Ch          ; 0x013 (Original 0x00F)
    RETLW 0BCh         ; 0x014 (Original 0x010)
    RETLW 00h          ; 0x015 (Original 0x011)
    RETLW 00h          ; 0x016 (Original 0x012)
    RETLW 2Ch          ; 0x017 (Original 0x013)
    RETLW 09Eh         ; 0x018 (Original 0x014)
    RETLW 00h          ; 0x019 (Original 0x015)
    RETLW 00h          ; 0x01A (Original 0x016)
    RETLW 2Fh          ; 0x01B (Original 0x017)
    RETLW 0Eh          ; 0x01C (Original 0x018)
    RETLW 00h          ; 0x01D (Original 0x019)
    RETLW 00h          ; 0x01E (Original 0x01A)
    RETLW 31h          ; 0x01F (Original 0x01B)
    RETLW 10h          ; 0x020 (Original 0x01C)
    RETLW 00h          ; 0x021 (Original 0x01D)
    RETLW 00h          ; 0x022 (Original 0x01E)
    RETLW 0C5h         ; 0x023 (Original 0x01F)
    RETLW 1Eh          ; 0x024 (Original 0x020)
    RETLW 00h          ; 0x025 (Original 0x021)
    RETLW 00h          ; 0x026 (Original 0x022)
    RETLW 32h          ; 0x027 (Original 0x023)
    RETLW 90h          ; 0x028 (Original 0x024)
    RETLW 00h          ; 0x029 (Original 0x025)
    RETLW 00h          ; 0x02A (Original 0x026)
    RETLW 0ACh         ; 0x02B (Original 0x027)
    RETLW 5Ch          ; 0x02C (Original 0x028)
    RETLW 00h          ; 0x02D (Original 0x029)
    RETLW 00h          ; 0x02E (Original 0x02A)
    RETLW 2Bh          ; 0x02F (Original 0x02B)
    RETLW 0C0h         ; 0x030 (Original 0x02C)

; Comparison Subroutine (0x031~0x03B)
ORG 0x031
COMP_SUB:
    BCF STATUS, RP0     ; Switch to Bank0
    BCF STATUS, RP1
    MOVLW 2Ch          
    MOVWF Reg10        
    MOVF Reg13,W       
    SUBWF Reg11,W      
    BCF STATUS,0       
    SUBWF Reg10,F      
    BTFSS STATUS,0     
    RETLW 01h          
    CALL TABLE_ENTRY   
    MOVWF Reg12        
    RETLW 00h          

; Fill Area (0x03C~0x0FF: 无地址覆盖，直接填充)
;ORG 0x03C
;REPT 0x0FF - 0x03C + 1    ; 重复填充指令（从0x03C到0x0FF共198条）
;    XORLW 0FFh         
;ENDM

; Main Program (0x100~0x19C)
ORG 0x100
MAIN:
    BCF STATUS, RP0     ; Switch to Bank0
    BCF STATUS, RP1

	BANKSEL PORTA ; select bank for PORTA
	CLRF PORTA ; Initialize PORTA by
	; clearing output
	; data latches
	BANKSEL ADCON1 ; Select Bank for ADCON1
	MOVLW 0x06 ; Configure all pins
	MOVWF ADCON1 ; as digital inputs
	MOVLW 0xFF ; Value used to
	; initialize data
	; direction
	MOVWF TRISA ; Set RA<3:0> as inputs
	; RA<5:4> as outputs
	; TRISA<7:6> are always
	; read as ‘0’.

    MOVLW 0Dh          
    OPTION             
    MOVWF STATUS       
    MOVWF FSR          
    MOVLW 00h          
    MOVWF Reg13        
    MOVLW 0Fh          
    TRIS PORTA         
    MOVLW 0FFh         
    TRIS PORTB         
    MOVLW 0FFh         
    TRIS PORTC        

; Read PortA (0x10B~0x111)
PTA_READ:
    BCF STATUS, RP0     
    BCF STATUS, RP1

    MOVF PORTA,W       
    MOVWF Reg10        
    MOVLW 0Fh          
    BCF STATUS,2       
    SUBWF Reg10,W      
    BTFSS STATUS,2     
    GOTO PTA_READ      

; Read PortB (0x112~0x118)
PTB_READ:
    BCF STATUS, RP0
    BCF STATUS, RP1

; 确保TRISB设为输入
    BSF STATUS, RP0    ; 切换到Bank1
    MOVLW 0xFF         ; 全输入
    MOVWF TRISB
    BCF STATUS, RP0    ; 切换回Bank0

    MOVF PORTB,W       
    MOVWF Reg10        
    MOVLW 0FFh         
    BCF STATUS,2       
    SUBWF Reg10,W      
    BTFSS STATUS,2     
    GOTO PTA_READ      

; Port Initialization (0x119~0x11C)
PORT_INIT:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 0Fh          
    TRIS PORTA         
    MOVLW 0FFh         
    TRIS PORTB         
    MOVLW 0FFh         
    TRIS PORTC        

; Watchdog Timer Reset Loop (0x11E~0x120)
WDT_RESET:
    BCF STATUS, RP0
    BCF STATUS, RP1
    CLRWDT             
    BTFSC PORTA,0      
    GOTO WDT_RESET     
    BTFSC PORTA,1      
    GOTO FUNCTION_194  
    
    MOVF PORTB,W       
    MOVWF Reg10        
    MOVLW 03h          
    TRIS PORTA         
    MOVLW 08h          
    MOVWF PORTA        

; Wait for PortA Bit0 to Set (0x129~0x12A)
PTA0_WAIT:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSS PORTA,0      
    GOTO PTA0_WAIT     
    MOVLW 0Fh          
    TRIS PORTA         
    BCF STATUS,2       
    MOVF Reg10,F       
    BTFSC STATUS,2     
    GOTO FUNCTION_13B  
    
    DECF Reg10,F       
    BTFSC STATUS,2     
    GOTO FUNCTION_14A  
    DECF Reg10,F       
    BTFSC STATUS,2     
    GOTO FUNCTION_153  
    DECF Reg10,F       
    BTFSC STATUS,2     
    GOTO FUNCTION_17A  
    DECF Reg10,F       
    BTFSC STATUS,2     
    GOTO FUNCTION_18B  

; Function Subroutine 13B: PortB Output 00h (0x13D~0x149)
FUNCTION_13B:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 00h          
    MOVWF Reg10        
    MOVLW 00h          
    TRIS PORTB         
    MOVLW 00h          
    MOVWF PORTB        
    MOVLW 0Ch          
    TRIS PORTA         
    MOVLW 00h          
    MOVWF PORTA        

; Wait for PortA Bit2 to Clear (0x147~0x148)
PTA2_WAIT:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSC PORTA,2      
    GOTO PTA2_WAIT     
    MOVLW 0Fh          
    MOVWF PORTA        
    GOTO PORT_INIT     

; Function Subroutine 14A: PortB Output 55h (0x14C~0x152)
FUNCTION_14A:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 00h          
    TRIS PORTB         
    MOVLW 55h          
    MOVWF PORTB        
    MOVLW 0Ch          
    TRIS PORTA         
    MOVLW 00h          
    MOVWF PORTA        
    GOTO PTA2_WAIT     

; Function Subroutine 153: Compare and Output Reg12 (0x155~0x179)
FUNCTION_153:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 0Ch          
    TRIS PORTA         
    MOVLW 02h          
    MOVWF PORTA        

; Wait for PortA Bit2 to Set (0x159~0x15A)
PTA2_WAIT_SET:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSC PORTA,2      
    GOTO PTA2_WAIT_SET 
    BTFSS PORTA,3      
    GOTO PORT_INIT     
    MOVLW 0FFh         
    TRIS PORTB         
    MOVF PORTB,W       
    MOVWF Reg11        
    MOVLW 0Fh          
    MOVWF PORTA        
    MOVLW 0Fh          
    TRIS PORTA         
    MOVLW 0FFh         
    TRIS PORTB         
    CALL COMP_SUB      
    MOVWF Reg14        
    BTFSC PORTA,0      
    GOTO $-1           
    BTFSS PORTA,1      
    GOTO FUNCTION_194  
    BCF STATUS,2       
    MOVF Reg14,F       
    BTFSS STATUS,2     
    GOTO FUNCTION_194  
    MOVLW 00h          
    TRIS PORTB         
    MOVF Reg12,W       
    MOVWF PORTB        
    MOVLW 03h          
    TRIS PORTA         
    MOVLW 08h          
    MOVWF PORTA        

; Wait for PortA Bit0 to Set (0x179~0x17A)
PTA0_WAIT_SET:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSS PORTA,0      
    GOTO PTA0_WAIT_SET 
    GOTO PORT_INIT     

; Function Subroutine 17A: PortC Read and PortB Add (0x17C~0x18A)
FUNCTION_17A:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 0FFh         
    TRIS PORTC         
    MOVF PORTC,W       
    MOVWF Reg13        
    MOVLW 0Ch          
    TRIS PORTA         
    MOVLW 02h          
    MOVWF PORTA        

; Wait for PortA Bit2 to Clear (0x184~0x185)
PTA2_WAIT_CLR:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSC PORTA,2      
    GOTO PTA2_WAIT_CLR 
    BTFSS PORTA,3      
    GOTO PORT_INIT     
    MOVLW 0FFh         
    TRIS PORTB         
    MOVF PORTB,W       
    ADDWF Reg13,F      
    GOTO PORT_INIT     

; Function Subroutine 18B: PortC to PortB Output (0x18D~0x193)
FUNCTION_18B:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 0Fh          
    TRIS PORTA         
    MOVLW 00h          
    TRIS PORTB         
FUNCTION_18C:
    MOVF PORTC,W       
    MOVWF PORTB        
    BTFSC PORTA,0      
    GOTO FUNCTION_18C
    GOTO WDT_RESET     

; Function Subroutine 194: PortA Initialization and Wait (0x196~0x19A)
FUNCTION_194:
    BCF STATUS, RP0
    BCF STATUS, RP1
    MOVLW 03h          
    TRIS PORTA         
    MOVLW 00h          
    MOVWF PORTA        

; Wait for PortA Bit0 to Clear (0x19A~0x19B)
PTA0_WAIT_CLR:
    BCF STATUS, RP0
    BCF STATUS, RP1
    BTFSS PORTA,0      
    GOTO PTA0_WAIT_CLR 
    GOTO PORT_INIT     

; Program End (0xFFF)
ORG 0x7FF
    GOTO MAIN          
    END                
