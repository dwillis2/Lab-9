#S = 0110 1101
#H = 0111 0110
#E = 0111 1001


.section .data
.section .bss
.section .text
.global _start

_start: 
    #Initialize Ports
    mov $0b10000000, %al #set bit command byte A
    mov $0x643, %dx #Program port 640 of device
    out %al, %dx #Display, I/O address 0x640

    #Initialize staritng position at dig-7
    mov $0b01111111, %bl

    main_loop:
    mov $5, %esi #Shift right 5 before reaching edge
scroll_right:
    mov $100, %edi           
refresh_right:
    #Display "SHE"

    #Display "S"
    mov $0b01101101, %al #Move S pattern into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send S pattern to Port B          

    mov %bl, %al #Load dig-7 into AL
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-7

    mov $5000, %ecx
    delay_s:
    loop delay_s

    #Disable "S"
    mov $0b11111111, %al
    out %al, %dx
    

    #Enable "H"
    mov $0b01110110, %al #Move H into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send H pattern to Port B

    mov %bl, %al #Load dig-6 into AL
    ror $1, %al #Rotate right 1 bit
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-6

    mov $5000, %ecx
    delay_h:
    loop delay_h

    #Disable H
    mov $0b11111111, %al
    out %al, %dx


    #Enable E
    mov $0b01111001, %al #Move E into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send E pattern to Port B

    mov %bl, %al #Load dig-5 into AL
    ror $2, %al #Rotate right 2 bits
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-5

    mov $5000, %ecx
    delay_e:
    loop delay_e

    #Disable E
    mov $0b11111111, %al
    out %al, %dx


    dec %edi
    jnz refresh_right

    ror $1, %bl #Shift to the right one
    dec %esi
    jnz scroll_right

    mov $5, %esi #Shift left 5 before reaching edge
scroll_left:
    mov $100, %edi # Hold "SHE" steady for 100 refreshes
refresh_left:

        #Display "SHE"

    #Display "S"
    mov $0b01101101, %al #Move S pattern into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send S pattern to Port B          

    mov %bl, %al #Load dig-7 into AL
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-7

    mov $5000, %ecx
    delay_s2:
    loop delay_s2

    #Disable "S"
    mov $0b11111111, %al
    out %al, %dx
    

    #Enable "H"
    mov $0b01110110, %al #Move H into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send H pattern to Port B

    mov %bl, %al #Load dig-6 into AL
    ror $1, %al #Rotate right 1 bit
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-6

    mov $5000, %ecx
    delay_h2:
    loop delay_h2

    #Disable H
    mov $0b11111111, %al
    out %al, %dx


    #Enable E
    mov $0b01111001, %al #Move E into AL
    mov $0x641, %dx #Move Port B address into DX
    out %al, %dx #Send E pattern to Port B

    mov %bl, %al #Load dig-5 into AL
    ror $2, %al #Rotate right 2 bits
    mov $0x640, %dx #Move Port A address into DX
    out %al, %dx #Enable dig-5

    mov $5000, %ecx
    delay_e2:
    loop delay_e2

    #Disable E
    mov $0b11111111, %al
    out %al, %dx

    dec %edi
    jnz refresh_left

    rol $1, %bl #Shift to the left one
    dec %esi
    jnz scroll_left

    jmp main_loop #Loop