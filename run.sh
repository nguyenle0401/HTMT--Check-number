#!/bin/bash

while true; do
    echo ""
    echo "========================================"
    echo "  MENU BAI TAP x86 ASSEMBLY"
    echo "========================================"
    echo "1. Bai 1 - So nguyen to"
    echo "2. Bai 2 - So hoan thien"
    echo "3. Bai 3 - So chinh phuong"
    echo "4. Bai 4 - So doi xung"
    echo "5. Bai 5 - Xu ly mang"
    echo "0. Thoat"
    echo "========================================"
    read -p "Chon (0-5): " choice

    case $choice in
        1)
            echo ""
            echo "=== BAI 1: SO NGUYEN TO ==="
            if [ ! -f "kiemtrasonguyento_x86" ]; then
                nasm -f elf32 kiemtrasonguyento_x86.asm -o kiemtrasonguyento_x86.o
                ld -m elf_i386 kiemtrasonguyento_x86.o -o kiemtrasonguyento_x86
            fi
            ./kiemtrasonguyento_x86
            ;;
        2)
            echo ""
            echo "=== BAI 2: SO HOAN THIEN ==="
            if [ ! -f "kiemtrasohoanthien_x86" ]; then
                nasm -f elf32 kiemtrasohoanthien_x86.asm -o kiemtrasohoanthien_x86.o
                ld -m elf_i386 kiemtrasohoanthien_x86.o -o kiemtrasohoanthien_x86
            fi
            ./kiemtrasohoanthien_x86
            ;;
        3)
            echo ""
            echo "=== BAI 3: SO CHINH PHUONG ==="
            if [ ! -f "kiemtrasochinhphuong_x86" ]; then
                nasm -f elf32 kiemtrasochinhphuong_x86.asm -o kiemtrasochinhphuong_x86.o
                ld -m elf_i386 kiemtrasochinhphuong_x86.o -o kiemtrasochinhphuong_x86
            fi
            ./kiemtrasochinhphuong_x86
            ;;
        4)
            echo ""
            echo "=== BAI 4: SO DOI XUNG ==="
            if [ ! -f "kiemtrasodoixung_x86" ]; then
                nasm -f elf32 kiemtrasodoixung_x86.asm -o kiemtrasodoixung_x86.o
                ld -m elf_i386 kiemtrasodoixung_x86.o -o kiemtrasodoixung_x86
            fi
            ./kiemtrasodoixung_x86
            ;;
        5)
            echo ""
            echo "=== BAI 5: XU LY MANG ==="
            if [ ! -f "xulimangsonguyen_x86" ]; then
                nasm -f elf32 xulimangsonguyen_x86.asm -o xulimangsonguyen_x86.o
                ld -m elf_i386 xulimangsonguyen_x86.o -o xulimangsonguyen_x86
            fi
            ./xulimangsonguyen_x86
            ;;
        0)
            echo "Tam biet!"
            exit 0
            ;;
        *)
            echo "Lua chon khong hop le!"
            ;;
    esac
done
