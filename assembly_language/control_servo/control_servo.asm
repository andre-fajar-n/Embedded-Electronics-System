start:
    setb p2.0
    mov TMOD, #00010000B
main_loop:
    jnb p2.0, pressed
    setb p0.0
    clr p0.1
    call kiri
    jmp main_loop
pressed:
    call kanan
    setb p0.1
    clr p0.0
    jmp main_loop  
;=====================================================
kiri:
    setb TR1
    mov TH1, #0FFH
    mov TL1, #05H
loop_high_kiri:
    setb p2.7
    jnb TF1, loop_high_kiri
    clr TF1
    mov TH1, #0D9H
    mov TL1, #0B2H
loop_low_kiri:
    clr p2.7
    jnb TF1, loop_low_kiri
    clr TF1
    ret
;=====================================================
kanan:
    setb TR1
    mov TH1, #0F8H
    mov TL1, #02FH
loop_high_kanan:
    setb p2.7
    jnb TF1, loop_high_kanan
    clr TF1
    mov TH1, #0B9H
    mov TL1, #0AFH
loop_low_kanan:
    clr p2.7
    jnb TF1, loop_low_kanan
    clr TF1
    ret
;=====================================================
end