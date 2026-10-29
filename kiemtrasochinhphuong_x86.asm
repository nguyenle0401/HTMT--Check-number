; ============================================================================
; Chuong trinh: Kiem tra so chinh phuong (x86 32-bit)
; ============================================================================

section .data
    msg_yes db "Day la so chinh phuong", 10, 0
    msg_no  db "Day khong phai so chinh phuong", 10, 0

section .text
    global _start

_start:
    ; Gan gia tri n can kiem tra
    mov     dword [n], 24       ; n = 64 (vi du: 0, 1, 4, 9, 16, 25, 64...)
    
    ; Kiem tra n < 0
    mov     eax, [n]
    test    eax, eax
    js      not_perfect_square  ; Neu n < 0 => khong phai so chinh phuong
    
    ; Kiem tra n == 0 hoac n == 1
    cmp     eax, 0
    je      is_perfect_square   ; 0 la so chinh phuong
    cmp     eax, 1
    je      is_perfect_square   ; 1 la so chinh phuong
    
    ; Thuat toan: Tim i sao cho i*i = n
    ; Bat dau tu i = 1
    mov     ecx, 1              ; ecx = i (so dang kiem tra)

check_loop:
    ; Tinh i * i
    mov     eax, ecx
    imul    eax, ecx            ; eax = i * i
    
    ; So sanh i*i voi n
    cmp     eax, [n]
    je      is_perfect_square   ; Neu i*i == n => la so chinh phuong
    jg      not_perfect_square  ; Neu i*i > n => khong phai so chinh phuong
    
    ; Tang i len 1
    inc     ecx                 ; i++
    jmp     check_loop          ; Tiep tuc vong lap

is_perfect_square:
    ; In "YES"
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, msg_yes
    mov     edx, 24             ; Độ dài đầy đủ: "Day la so chinh phuong\n"
    int     0x80
    jmp     exit

not_perfect_square:
    ; In "NO"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_no
    mov     edx, 32             ; Độ dài đầy đủ: "Day khong phai so chinh phuong\n"
    int     0x80

exit:
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx
    int     0x80

section .bss
    n resd 1                    ; Bien luu gia tri n

; ============================================================================
; GHI CHU:
; - eax: tinh toan i*i va syscall
; - ecx: i (so dang kiem tra)
;
; Thuat toan:
; 1. Kiem tra n < 0 => khong phai so chinh phuong
; 2. Kiem tra n = 0 hoac n = 1 => la so chinh phuong
; 3. Tim i sao cho i*i = n
;    - Neu tim thay => la so chinh phuong
;    - Neu i*i > n => khong phai so chinh phuong
;
; Do phuc tap: O(sqrt(n))
;
; Cac so chinh phuong de test:
; - mov dword [n], 0    -> YES (0 = 0*0)
; - mov dword [n], 1    -> YES (1 = 1*1)
; - mov dword [n], 4    -> YES (4 = 2*2)
; - mov dword [n], 9    -> YES (9 = 3*3)
; - mov dword [n], 16   -> YES (16 = 4*4)
; - mov dword [n], 25   -> YES (25 = 5*5)
; - mov dword [n], 64   -> YES (64 = 8*8)
; - mov dword [n], 100  -> YES (100 = 10*10)
;
; Cac so KHONG phai chinh phuong:
; - mov dword [n], 2    -> NO
; - mov dword [n], 8    -> NO
; - mov dword [n], 15   -> NO
; - mov dword [n], 50   -> NO
;
; CACH BUILD VA CHAY:
; nasm -f elf32 kiemtrasochinhphuong_x86.asm -o kiemtrasochinhphuong_x86.o
; ld -m elf_i386 kiemtrasochinhphuong_x86.o -o kiemtrasochinhphuong_x86
; ./kiemtrasochinhphuong_x86
; ============================================================================