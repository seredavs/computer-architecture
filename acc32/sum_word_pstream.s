    .text
    .org         0x88

_start:
    load    addr_in
    load_acc
    ble          handle_incorrect_N          ; if N<0 return -1
    store        n                           ; save N to memory
    store        i_iterator                  ; change pointer to tje current element

    load_imm     0
    store        lw                          ; change right summ to 0
    store        hw                          ; change left summ to 0

loop_body:
    load         i_iterator                  ; checking the iterator
    beqz         loop_finished               ; if i == 0 exit the loop

    ; reading from 0x80 too
    load_addr    0x80                        ; take the number from the stream (acc = xs[i])

    store        temp_xs                     ; save number for checking
    beqz         is_positive                 ; if number == 0: go to adding
    bgt          is_positive                 ; if number > 0: go to adding

    load         hw                          ; load hw for extension
    sub          const_1                     ; hw - 1 (extension)
    store        hw

is_positive:
    load         temp_xs                     ;take number to acc

    add          lw                          ; acc = xs[i] + lw
    store        lw                          ; update lw

    bcc          step_next                   ; if C=0: go to the next number

    ; else: hw += 1
    load         hw
    add          const_1

    bvs          handle_ovf                  ;if V!=0: go to error

    store        hw                          ; save new hw

step_next:
    ; preparing for the new loop
    load         i_iterator                  ;  i -= 1
    sub          const_1
    store        i_iterator

    jmp          loop_body                   ; go to start of loop

loop_finished:
    ; returning hw, lw (to 0x84)
    load         hw
    store_ind    addr_out                        ; save High Word to addr 0x84

    load         lw
    store_ind    addr_out                        ; save Low Word to addr 0x84

    jmp          exit

handle_incorrect_N:
    load         error_incorrect_N
    store_ind    addr_out                        ; output -1 for hw
    store_ind    addr_out                        ; output -1 for lw
    jmp          exit


handle_ovf:
    load         error_overflow
    store_ind    addr_out                        ; output error for hw
    store_ind    addr_out                        ; output error for lw
    jmp          exit

exit:
    halt

    .data

n:               .word  0                  ; number of elements
i_iterator:      .word  0                  ; iterator for loop (from n to 0)

lw:              .word  0
hw:              .word  0

const_1:         .word  1                  ; constant for inc/dec
error_incorrect_N: .word  0xFFFFFFFF       ; code error N<0
error_overflow:  .word  0xCCCCCCCC         ; code error of overflow (64 bit)
temp_xs:         .word  0


addr_in:         .word  0x80
addr_out:        .word  0x84
