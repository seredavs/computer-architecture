    .data

.org             0x90
    .text
_start:
    movea.l  0x70, A7                        ; stack pointer
    movea.l  0x80, A1                        ; input port
    movea.l  0x84, A2                        ; output port
    movea.l  0x00, A3                        ; start of buffer in RAM
    move.l   0, D7                           ; lenght counter (<64)

read_loop:
    move.l   0, D0
    move.b   (A1), D0                        ; read number of letter

    cmp.l    10, D0                          ; if it != end of line
    beq      print_buffer                    ; else: print result

    cmp.l    49, D0
    blt      error_format_flush              ; if <1 => error
    cmp.l    57, D0
    bgt      error_format_flush              ; if >9 => error

    sub.l    48, D0                          ; convert ASCII in normal count

    move.l   0, D1
    move.b   (A1), D1                        ; read letter

    cmp.l    10, D1
    beq      error_format_no_flush           ; if letter='\n' => error

    add.l    D0, D7                          ; multilpy letter
    cmp.l    64, D7                          ; check buffer size
    beq      error_overflow_no_flush
    bgt      error_overflow_flush

write_chars:
    move.b   D1, (A3)+                       ; if counter != 0: adding a symbol
    sub.l    1, D0
    bne      write_chars

    jmp      read_loop                       ; else: read next pair

print_buffer:
    move.b   0, (A3)

    ; save parameters in stack
    move.l   0x84, -(A7)
    move.l   0, -(A7)

    jsr      print_subroutine

    move.l   (A7)+, D0
    move.l   (A7)+, D0

    jmp      end_prog

end_prog:
    halt

print_subroutine:
    link     A6, 0

    movea.l  8(A6), A4
    movea.l  12(A6), A5

print_loop:
    move.l   0, D2
    move.b   (A4)+, D2
    cmp.l    0, D2
    beq      print_done

    move.b   D2, (A5)
    jmp      print_loop

print_done:
    unlk     A6
    rts


error_format_flush:
    move.l   -1, D0
    move.l   D0, (A2)
    jmp      flush_input

error_format_no_flush:
    move.l   -1, D0
    move.l   D0, (A2)
    halt

error_overflow_no_flush:
 ; 0xCCCCCCCC error
    move.l   -858993460, D0
    move.l   D0, (A2)
    halt

error_overflow_flush:
 ; 0xCCCCCCCC error with clean buffer
    move.l   -858993460, D0
    move.l   D0, (A2)
    jmp      flush_input

flush_input:
 ; adding symbols, while symbol != Enter
    move.l   0, D2
    move.b   (A1), D2
    cmp.l    10, D2
    beq      end_prog
    jmp      flush_input
