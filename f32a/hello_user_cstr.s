    .data
.org             0x00
buf:             .byte  'Hello, \0________________________'
vopros:          .byte  'What is your name?\n\0'
znak_v:          .word  33
znak_0:          .word  0
sdvig:           .word  7
limit:           .word  29
enter:           .word  10
port_in:         .word  0x80
port_out:        .word  0x84
oshibka:         .word  -858993460

    .text
    .org 0x88

_start:
    @p port_out b!
    lit vopros a!
    print_string

    @p sdvig a!
    @p port_in b!

read_loop:
    @b
    lit 0xFF and

    dup @p enter xor if end_read_normal
    dup if handle_null_in_middle

    a @p limit xor if handle_overflow

    store_char
    read_loop ;

handle_null_in_middle:
    drop
flush_loop:
    @b
    lit 0xFF and
    dup @p enter xor if end_read_from_flush
    drop
    flush_loop ;

end_read_from_flush:
    drop
    print_result ;

end_read_normal:
    drop
    a @p sdvig xor if handle_overflow_empty

print_result:
    @p znak_v store_char
    @p znak_0 store_char

    @p port_out b!
    lit buf a!
    print_string
    halt

handle_overflow:
    drop
handle_overflow_empty:
    @p oshibka
    @p port_out b!
    !b
    halt

print_string:
    @+
    lit 0xFF and
    dup if return
    !b
    print_string ;

return:
    drop
    ;

store_char:
    @
    lit 0xFFFFFF00 and
    +
    !+
    ;
