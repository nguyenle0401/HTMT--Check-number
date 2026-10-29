; ============================================================================
; Chuong trinh: Kiem tra so hoan thien (x86 32-bit)
; ============================================================================

section .data
    msg_yes db "Day la so hoan thien", 10, 0
    msg_no  db "Day khong phai so hoan thien", 10, 0

section .text
    global _start

_start:
    ; Gan gia tri n can kiem tra
    mov     dword [n], 2       ; n = 28 (vi du: 6, 28, 496, 8128)
    
    ; Kiem tra n <= 1
    mov     eax, [n]
    cmp     eax, 1
    jle     not_perfect         ; Neu n <= 1 => khong phai so hoan thien
    
    ; Khoi tao tong cac uoc so
    xor     ebx, ebx            ; ebx = sum = 0 (tong cac uoc)
    mov     ecx, 1              ; ecx = i = 1 (bat dau tu 1)
    
    ; Tinh n/2 de giam so lan lap
    mov     eax, [n]
    xor     edx, edx
    mov     esi, 2
    div     esi                 ; eax = n/2
    mov     edi, eax            ; edi = n/2 (gioi han)

find_divisors:
    ; Kiem tra neu i > n/2 thi dung
    cmp     ecx, edi
    jg      check_sum           ; Neu i > n/2 => ket thuc vong lap
    
    ; Kiem tra n % i == 0
    mov     eax, [n]            ; eax = n
    xor     edx, edx            ; edx = 0
    div     ecx                 ; eax = n/i, edx = n%i
    
    test    edx, edx
    jnz     next_divisor        ; Neu n % i != 0 => khong phai uoc so
    
    ; i la uoc so cua n, cong vao tong
    add     ebx, ecx            ; sum += i

next_divisor:
    ; Tang i len 1
    inc     ecx                 ; i++
    jmp     find_divisors       ; Tiep tuc vong lap

check_sum:
    ; So sanh tong cac uoc voi n
    cmp     ebx, [n]
    je      is_perfect          ; Neu sum == n => la so hoan thien
    jmp     not_perfect         ; Nguoc lai => khong phai so hoan thien

is_perfect:
    ; In "YES"
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, msg_yes
    mov     edx, 20             ; Độ dài đầy đủ: "Day la so hoan thien\n"
    int     0x80
    jmp     exit

not_perfect:
    ; In "NO"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_no
    mov     edx, 30             ; Độ dài đầy đủ: "Day khong phai so hoan thien\n"
    int     0x80

exit:
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx
    int     0x80

section .bss
    n resd 1                    ; Bien luu gia tri n

; ============================================================================
; GHI CHU:
; - eax: tinh toan va syscall
; - ebx: sum (tong cac uoc so)
; - ecx: i (bien dem, uoc so hien tai)
; - edx: phan du khi chia
; - edi: n/2 (gioi han tren)
; - esi: hang so tam thoi
;
; Thuat toan:
; 1. Kiem tra n <= 1 => khong phai so hoan thien
; 2. Duyet i tu 1 den n/2
; 3. Neu i la uoc so cua n (n % i == 0) thi cong i vao sum
; 4. Sau khi duyet xong, so sanh sum voi n
;
; Cac so hoan thien de test:
; - mov dword [n], 6    -> YES (6 = 1+2+3)
; - mov dword [n], 28   -> YES (28 = 1+2+4+7+14)
; - mov dword [n], 496  -> YES
;
; Cac so khong phai:
; - mov dword [n], 12   -> NO
; - mov dword [n], 100  -> NO
;
; CACH BUILD VA CHAY:
; nasm -f elf32 kiemtrasohoanthien_x86.asm -o kiemtrasohoanthien_x86.o
; ld -m elf_i386 kiemtrasohoanthien_x86.o -o kiemtrasohoanthien_x86
; ./kiemtrasohoanthien_x86
; ============================================================================