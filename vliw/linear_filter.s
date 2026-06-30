    .text
_start:
    addi a0, zero, 0x80 / addi a1, zero, 0x84 / nop          / nop
    addi a3, zero, 3    / addi a4, zero, 2    / lw t0, 0(a0) / nop
    add s1, zero, zero  / add s2, zero, zero  / nop          / beqz t0, end
loop:
    addi t0, t0, -1     / nop                 / lw t1, 0(a0) / nop
    mul t3, t1, a3      / mul t4, s1, a4      / nop          / nop
    add t5, t3, t4      / nop                 / nop          / nop
    add t2, t5, s2      / mv s2, s1           / nop          / nop
    mv s1, t1           / nop                 / sw t2, 0(a1) / bnez t0, loop
end:
    nop                 / nop                 / nop          / halt
