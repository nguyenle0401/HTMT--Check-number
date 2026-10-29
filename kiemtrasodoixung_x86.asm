; ============================================================================
; Chuong trinh: Kiem tra so doi xung (x86 32-bit)
; ============================================================================

section .data
    msg_yes db "Day la so doi xung", 10, 0
    msg_no  db "Day khong phai so doi xung", 10, 0

section .text
    global _start

_start:
    ; Gan gia tri n can kiem tra
    mov     dword [n], 12      ; n = 121 (vi du: 121, 12321, 1001...)
    
    ; Luu lai gia tri goc de so sanh sau
    mov     eax, [n]
    mov     [n_original], eax   ; n_original = n
    
    ; Kiem tra so am
    test    eax, eax
    js      not_palindrome      ; So am khong phai so doi xung
    
    ; Kiem tra so 0-9 (1 chu so)
    cmp     eax, 10
    jl      is_palindrome       ; So 1 chu so la so doi xung
    
    ; Dao nguoc so n
    xor     ebx, ebx            ; ebx = reversed = 0
    mov     ecx, eax            ; ecx = temp = n

reverse_loop:
    test    ecx, ecx
    jz      check_palindrome    ; Neu temp == 0, ket thuc dao nguoc
    
    ; Lay chu so cuoi cung: digit = temp % 10
    mov     eax, ecx            ; eax = temp
    xor     edx, edx            ; edx = 0
    mov     esi, 10
    div     esi                 ; eax = temp/10, edx = temp%10
    
    ; reversed = reversed * 10 + digit
    imul    ebx, 10             ; reversed *= 10
    add     ebx, edx            ; reversed += digit
    
    ; temp = temp / 10
    mov     ecx, eax            ; temp = temp / 10
    
    jmp     reverse_loop        ; Tiep tuc vong lap

check_palindrome:
    ; So sanh so goc voi so dao nguoc
    mov     eax, [n_original]
    cmp     eax, ebx
    je      is_palindrome       ; Neu n_original == reversed => doi xung
    jmp     not_palindrome      ; Nguoc lai => khong doi xung

is_palindrome:
    ; In "YES"
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, msg_yes
    mov     edx, 20
    int     0x80
    jmp     exit

not_palindrome:
    ; In "NO"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_no
    mov     edx, 32
    int     0x80

exit:
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx
    int     0x80

section .bss
    n           resd 1          ; So can kiem tra
    n_original  resd 1          ; Luu gia tri goc

; ============================================================================
; GHI CHU:
; - eax: tinh toan tam thoi
; - ebx: reversed (so dao nguoc)
; - ecx: temp (bien tam)
; - edx: chu so cuoi cung (temp % 10)
; - esi: hang so 10
;
; Thuat toan dao nguoc so:
; Vi du: n = 121
; 1. reversed = 0, temp = 121
; 2. digit = 121%10 = 1, reversed = 0*10+1 = 1, temp = 12
; 3. digit = 12%10 = 2, reversed = 1*10+2 = 12, temp = 1
; 4. digit = 1%10 = 1, reversed = 12*10+1 = 121, temp = 0
; 5. So sanh: 121 == 121 => Doi xung!
;
; Do phuc tap: O(log n) - so chu so cua n
;
; Cac so doi xung de test:
; - mov dword [n], 0      -> YES
; - mov dword [n], 7      -> YES
; - mov dword [n], 11     -> YES
; - mov dword [n], 121    -> YES
; - mov dword [n], 1001   -> YES
; - mov dword [n], 12321  -> YES
;
; Cac so KHONG doi xung:
; - mov dword [n], 10     -> NO
; - mov dword [n], 12     -> NO
; - mov dword [n], 123    -> NO
; - mov dword [n], 100    -> NO
;
; CACH BUILD VA CHAY:
; nasm -f elf32 kiemtrasodoixung_x86.asm -o kiemtrasodoixung_x86.o
; ld -m elf_i386 kiemtrasodoixung_x86.o -o kiemtrasodoixung_x86
; ./kiemtrasodoixung_x86
; ============================================================================