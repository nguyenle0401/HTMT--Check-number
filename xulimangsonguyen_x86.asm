; ============================================================================
; Chuong trinh: Xu ly mang so nguyen (x86 32-bit - su dung ky thuat ham)
; ============================================================================

section .data
    ; Test data (thay cho nhap thu cong)
    array dd 12, 17, 4, 23, 15  ; Mang test: [12, 17, 4, 23, 15]
    n dd 5                      ; So phan tu
    
    ; Messages
    msg_array   db "Mang: ", 0
    msg_primes  db "Nguyen to: ", 0
    msg_max     db "Max = ", 0
    msg_avg     db "Trung binh = ", 0
    msg_space   db " ", 0
    msg_newline db 10, 0
    
    ; Buffer de chuyen doi so -> chuoi
    buffer times 12 db 0

section .bss
    option resd 1               ; Lua chon chuc nang

section .text
    global _start

_start:
    ; CHAY TAT CA CAC CHUC NANG
    
    ; 1. In mang goc
    call    run_print_array
    
    ; 2. Liet ke so nguyen to
    call    run_list_primes
    
    ; 3. Tim max
    call    run_find_max
    
    ; 4. Tinh trung binh
    call    run_calculate_avg
    
    jmp     exit

; ============================================================================
; WRAPPER FUNCTIONS - Chay tat ca chuc nang
; ============================================================================
run_print_array:
    push    msg_array
    call    print_string
    add     esp, 4
    
    push    dword [n]
    push    array
    call    print_array
    add     esp, 8
    
    push    msg_newline
    call    print_string
    add     esp, 4
    ret

run_list_primes:
    push    msg_primes
    call    print_string
    add     esp, 4
    
    mov     ecx, [n]
    mov     esi, array
    
run_list_primes_loop:
    cmp     ecx, 0
    je      run_list_primes_done
    
    mov     eax, [esi]
    push    ecx
    push    esi
    push    eax
    call    is_prime
    add     esp, 4
    pop     esi
    pop     ecx
    
    cmp     eax, 1
    jne     run_list_primes_next
    
    push    ecx
    push    esi
    push    dword [esi]
    call    print_number
    add     esp, 4
    push    msg_space
    call    print_string
    add     esp, 4
    pop     esi
    pop     ecx
    
run_list_primes_next:
    add     esi, 4
    dec     ecx
    jmp     run_list_primes_loop
    
run_list_primes_done:
    push    msg_newline
    call    print_string
    add     esp, 4
    ret

run_find_max:
    push    msg_max
    call    print_string
    add     esp, 4
    
    push    dword [n]
    push    array
    call    find_max
    add     esp, 8
    
    push    eax
    call    print_number
    add     esp, 4
    
    push    msg_newline
    call    print_string
    add     esp, 4
    ret

run_calculate_avg:
    push    msg_avg
    call    print_string
    add     esp, 4
    
    push    dword [n]
    push    array
    call    calculate_avg
    add     esp, 8
    
    push    eax
    call    print_number
    add     esp, 4
    
    push    msg_newline
    call    print_string
    add     esp, 4
    ret

; ============================================================================
; CAC OPTION FUNCTIONS CU - KHONG SU DUNG NUA
; ============================================================================
; (Cac ham nay da duoc thay the boi cac wrapper function o tren)

; ============================================================================
; HAM: PRINT_ARRAY
; Tham so: [esp+4] = dia chi mang, [esp+8] = so phan tu
; ============================================================================
print_array:
    push    ebp
    mov     ebp, esp
    push    esi
    push    ecx
    
    mov     esi, [ebp+8]        ; esi = dia chi mang
    mov     ecx, [ebp+12]       ; ecx = n
    
print_array_loop:
    cmp     ecx, 0
    je      print_array_done
    
    ; In phan tu hien tai
    push    ecx
    push    esi
    push    dword [esi]
    call    print_number
    add     esp, 4
    pop     esi
    pop     ecx
    
    ; In space
    push    ecx
    push    esi
    push    msg_space
    call    print_string
    add     esp, 4
    pop     esi
    pop     ecx
    
    add     esi, 4
    dec     ecx
    jmp     print_array_loop
    
print_array_done:
    pop     ecx
    pop     esi
    pop     ebp
    ret

; ============================================================================
; HAM: IS_PRIME
; Tham so: [esp+4] = so can kiem tra
; Tra ve: eax = 1 (nguyen to), 0 (khong)
; ============================================================================
is_prime:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    
    mov     eax, [ebp+8]        ; eax = n
    
    ; Kiem tra n < 2
    cmp     eax, 2
    jl      is_prime_no
    
    ; Kiem tra n == 2
    cmp     eax, 2
    je      is_prime_yes
    
    ; Kiem tra n == 3
    cmp     eax, 3
    je      is_prime_yes
    
    ; Kiem tra chan
    test    eax, 1
    jz      is_prime_no
    
    ; Kiem tra cac uoc tu 3 den sqrt(n)
    mov     ebx, eax            ; Luu n
    mov     ecx, 3              ; i = 3
    
is_prime_loop:
    mov     eax, ecx
    imul    eax, ecx            ; eax = i*i
    cmp     eax, ebx
    jg      is_prime_yes        ; i*i > n => nguyen to
    
    mov     eax, ebx            ; eax = n
    xor     edx, edx
    div     ecx                 ; eax = n/i, edx = n%i
    test    edx, edx
    jz      is_prime_no         ; n%i == 0 => khong nguyen to
    
    add     ecx, 2              ; i += 2
    jmp     is_prime_loop
    
is_prime_yes:
    mov     eax, 1
    jmp     is_prime_done
    
is_prime_no:
    xor     eax, eax
    
is_prime_done:
    pop     ecx
    pop     ebx
    pop     ebp
    ret

; ============================================================================
; HAM: FIND_MAX
; Tham so: [esp+4] = dia chi mang, [esp+8] = so phan tu
; Tra ve: eax = gia tri max
; ============================================================================
find_max:
    push    ebp
    mov     ebp, esp
    push    esi
    push    ecx
    
    mov     esi, [ebp+8]        ; esi = dia chi mang
    mov     ecx, [ebp+12]       ; ecx = n
    
    mov     eax, [esi]          ; max = phan tu dau tien
    add     esi, 4
    dec     ecx
    
find_max_loop:
    cmp     ecx, 0
    je      find_max_done
    
    mov     ebx, [esi]          ; ebx = phan tu hien tai
    cmp     ebx, eax
    jle     find_max_skip
    mov     eax, ebx            ; Cap nhat max
    
find_max_skip:
    add     esi, 4
    dec     ecx
    jmp     find_max_loop
    
find_max_done:
    pop     ecx
    pop     esi
    pop     ebp
    ret

; ============================================================================
; HAM: CALCULATE_AVG
; Tham so: [esp+4] = dia chi mang, [esp+8] = so phan tu
; Tra ve: eax = trung binh (phan nguyen)
; ============================================================================
calculate_avg:
    push    ebp
    mov     ebp, esp
    push    esi
    push    ecx
    push    ebx
    
    mov     esi, [ebp+8]        ; esi = dia chi mang
    mov     ecx, [ebp+12]       ; ecx = n
    xor     ebx, ebx            ; ebx = sum = 0
    
calc_avg_loop:
    cmp     ecx, 0
    je      calc_avg_done
    
    add     ebx, [esi]          ; sum += arr[i]
    add     esi, 4
    dec     ecx
    jmp     calc_avg_loop
    
calc_avg_done:
    mov     eax, ebx            ; eax = sum
    xor     edx, edx
    div     dword [ebp+12]      ; eax = sum / n
    
    pop     ebx
    pop     ecx
    pop     esi
    pop     ebp
    ret

; ============================================================================
; HAM: PRINT_NUMBER
; Tham so: [esp+4] = so can in
; ============================================================================
print_number:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    edi
    
    mov     eax, [ebp+8]        ; eax = so can in
    mov     edi, buffer + 11    ; edi = cuoi buffer
    mov     byte [edi], 0       ; Null terminator
    dec     edi
    mov     ecx, 10             ; Base 10
    
    ; Xu ly so 0
    test    eax, eax
    jnz     print_number_loop
    mov     byte [edi], '0'
    jmp     print_number_print
    
print_number_loop:
    test    eax, eax
    jz      print_number_print
    
    xor     edx, edx
    div     ecx                 ; eax = eax/10, edx = eax%10
    add     dl, '0'             ; Chuyen sang ASCII
    mov     [edi], dl
    dec     edi
    jmp     print_number_loop
    
print_number_print:
    inc     edi                 ; Tro toi ky tu dau tien
    push    edi
    call    print_string
    add     esp, 4
    
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    pop     ebp
    ret

; ============================================================================
; HAM: PRINT_STRING
; Tham so: [esp+4] = dia chi chuoi (null-terminated)
; ============================================================================
print_string:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    push    edx
    
    mov     ecx, [ebp+8]        ; ecx = dia chi chuoi
    
    ; Tinh do dai chuoi
    mov     edx, ecx
print_string_len:
    cmp     byte [edx], 0
    je      print_string_write
    inc     edx
    jmp     print_string_len
    
print_string_write:
    sub     edx, ecx            ; edx = do dai
    
    ; sys_write
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    int     0x80
    
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    pop     ebp
    ret

; ============================================================================
exit:
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx
    int     0x80

; ============================================================================
; GHI CHU:
; Test data: [12, 17, 4, 23, 15]
; - Nguyen to: 17, 23
; - Max: 23
; - Trung binh: (12+17+4+23+15)/5 = 71/5 = 14
;
; DE TEST CAC CHUC NANG:
; Sua dong "mov dword [option], 2":
; - 2: In mang -> "Mang: 12 17 4 23 15"
; - 3: So nguyen to -> "Nguyen to: 17 23"
; - 4: Max -> "Max = 23"
; - 5: Trung binh -> "Trung binh = 14"
;
; KY THUAT HAM:
; - Su dung stack frame (ebp)
; - Push/pop de luu/khoi phuc thanh ghi
; - Truyen tham so qua stack
; - Tra ve ket qua qua eax
;
; CACH BUILD VA CHAY:
; nasm -f elf32 xulimangsonguyento_x86.asm -o xulimangsonguyento_x86.o
; ld -m elf_i386 xulimangsonguyento_x86.o -o xulimangsonguyento_x86
; ./xulimangsonguyento_x86
; ============================================================================