; ============================================================================
; Chuong trinh: Kiem tra so nguyen to (x86 32-bit)
; ============================================================================

section .data
    msg_yes db "YES", 10, 0         
    msg_no  db "NO", 10, 0
    len_yes equ $ - msg_yes
    len_no  equ $ - msg_no

section .bss

section .text
    global _start

_start:
    ; Gan gia tri n can kiem tra
    ; Thay doi gia tri nay de test cac so khac
    mov     dword [n], 1       ; n = 17 (vi du: 2, 3, 5, 7, 11, 13, 17...)
    
    ; Kiem tra cac truong hop dac biet
    mov     eax, [n]            ; Load n vao eax
    cmp     eax, 2
    jl      not_prime           ; Neu n < 2 => khong la so nguyen to
    
    cmp     eax, 2
    je      is_prime            ; Neu n == 2 => la so nguyen to
    
    cmp     eax, 3
    je      is_prime            ; Neu n == 3 => la so nguyen to
    
    ; Kiem tra n co chia het cho 2 khong
    test    eax, 1              ; Kiem tra bit cuoi cung
    jz      not_prime           ; Neu n chan => khong la so nguyen to

    ; Khoi tao vong lap kiem tra tu i = 3
    mov     ecx, 3              ; ecx = i = 3 (so chia)
    
check_loop:
    ; Tinh i * i
    mov     eax, ecx
    imul    eax, ecx            ; eax = i * i
    
    ; So sanh i * i voi n
    cmp     eax, [n]
    jg      is_prime            ; Neu i*i > n => la so nguyen to
    
    ; Kiem tra n % i == 0
    mov     eax, [n]            ; eax = n
    xor     edx, edx            ; edx = 0 (cho phep chia)
    div     ecx                 ; eax = n/i, edx = n%i
    
    test    edx, edx
    jz      not_prime           ; Neu n % i == 0 => khong la so nguyen to
    
    ; Tang i len 2 (chi kiem tra so le)
    add     ecx, 2              ; i += 2
    jmp     check_loop          ; Tiep tuc vong lap

is_prime:
    ; In "YES"
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, msg_yes        ; buffer
    mov     edx, 4              ; length
    int     0x80
    jmp     exit

not_prime:
    ; In "NO"
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, msg_no         ; buffer
    mov     edx, 3              ; length
    int     0x80

exit:
    ; Thoat chuong trinh
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx            ; exit code = 0
    int     0x80

section .data
    n dd 0                      ; Bien luu gia tri n

; ============================================================================
; GHI CHU:
; - eax: thanh ghi da nang, dung cho tinh toan va syscall
; - ebx: tham so cho syscall
; - ecx: bien dem i trong vong lap
; - edx: luu phan du khi chia
;
; Thuat toan:
; 1. Kiem tra n < 2 => khong phai so nguyen to
; 2. Kiem tra n = 2 hoac n = 3 => la so nguyen to
; 3. Kiem tra n chan => khong phai so nguyen to
; 4. Kiem tra cac so le tu 3 den sqrt(n)
;    - Neu n chia het cho i => khong phai so nguyen to
;    - Neu khong co so nao chia het => la so nguyen to
;
; Do phuc tap: O(sqrt(n))
;
; Cac so nguyen to de test:
; - mov dword [n], 2    -> YES
; - mov dword [n], 3    -> YES
; - mov dword [n], 5    -> YES
; - mov dword [n], 7    -> YES
; - mov dword [n], 11   -> YES
; - mov dword [n], 17   -> YES (hien tai)
; - mov dword [n], 23   -> YES
;
; Cac so KHONG phai nguyen to:
; - mov dword [n], 1    -> NO
; - mov dword [n], 4    -> NO
; - mov dword [n], 6    -> NO
; - mov dword [n], 9    -> NO
; - mov dword [n], 15   -> NO
;
; CACH BUILD VA CHAY:
; nasm -f elf32 kiemtrasonguyento_x86.asm -o kiemtrasonguyento_x86.o
; ld -m elf_i386 kiemtrasonguyento_x86.o -o kiemtrasonguyento_x86
; ./kiemtrasonguyento_x86
; ============================================================================