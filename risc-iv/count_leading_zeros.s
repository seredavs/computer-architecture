    .data
stack_top:       .word  2048
io_input:        .word  0x80
io_output:       .word  0x84

    .text
    .org     0x100
_start:

    ; work with stack
    lui      t0, %hi(stack_top)
    addi     t0, t0, %lo(stack_top)
    lw       sp, 0(t0)

    ; read n
    lui      t0, %hi(io_input)
    addi     t0, t0, %lo(io_input)
    lw       t1, 0(t0)
    lw       a0, 0(t1)

    jal      ra, solve

    ; print result
    lui      t0, %hi(io_output)
    addi     t0, t0, %lo(io_output)
    lw       t1, 0(t0)
    sw       a0, 0(t1)
    halt

solve:
    addi     sp, sp, -16
    sw       ra, 12(sp)

    bnez     a0, start_rec                   ; if n == 0: return 32
    addi     a0, zero, 32
    j        solve_end

start_rec:
    addi     a1, zero, 0                     ; cnt = 0
    jal      ra, clz_rec                     ; call recursion
    mv       a0, a1                          ; result in a0

solve_end:
    lw       ra, 12(sp)
    addi     sp, sp, 16
    jr       ra

clz_rec:
    addi     sp, sp, -16
    sw       ra, 12(sp)

    ; check high bit: if 0 > a0 => a0 is negative => 31 bit is 1
    bgt      zero, a0, rec_exit

    add      a0, a0, a0                      ; go left (n = n + n)
    addi     a1, a1, 1                       ; cnt++

    jal      ra, clz_rec                     ; recursion

rec_exit:
    lw       ra, 12(sp)
    addi     sp, sp, 16
    jr       ra
