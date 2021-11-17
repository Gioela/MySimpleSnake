.org $8000 ; program starts from here
.define pxl_color $0A
.define pxl_pos  $76
.define pxl_none $00
.define pag_mem $0200
.define input_mem $4000
.define cmd_u $01
.define cmd_d $02
.define cmd_r $08
.define cmd_l $04

; reset_stack:
;     LDX #$FF
;     TXS

; it creates and positioned pixel in cell memory
init_pixel:
    LDX #pxl_pos
    ;LDY #cmd_pressed
    LDA #pxl_color
    STA $0200,X
    RTS

init_game:
    ; stack cleaning
    LDX #$FF
    TXS
    ; init pixel position
    JSR init_pixel

gameloop:
    JSR check_cmd
    ; JSR rigth_loop
    JSR gameloop

check_cmd:
    LDA input_mem
    AND #cmd_r
    BNE move_rigth_loop

    LDA input_mem
    AND #cmd_l
    BNE move_left_loop

    LDA input_mem
    AND #cmd_u
    BNE move_up_loop

    LDA input_mem
    AND #cmd_d
    BNE move_down_loop

    RTS

blank_pxl:
    LDA #pxl_none
    STA pag_mem,X   ; hide old pixel position
    RTS

draw_up_down_pxl:
    TAX
    LDA #pxl_color  ; load pixel color in A
    STA pag_mem,X   ; in pag_mem, find X position and store here the A value
    RTS

move_up_loop:
    JSR blank_pxl
    TXA             ; transfer X to A
    SBC #$0F        ; decrement A value by F
    JSR draw_up_down_pxl
    RTS

move_down_loop:
    JSR blank_pxl
    TXA             ; transfer X to A
    ADC #$0F        ; decrement A value by F
    JSR draw_up_down_pxl
    RTS

move_rigth_loop:
    JSR blank_pxl
    LDA #pxl_color  ; load pixel color in A
    INX             ; increment X value by 1
    STA pag_mem,X   ; in pag_mem, find X position and store here the A value
    RTS

move_left_loop:
    JSR blank_pxl
    LDA #pxl_color  ; load pixel color in A
    DEX             ; decrement X value by 1
    STA pag_mem,X   ; in pag_mem, find X position and store here the A value
    RTS

LDA #$22

interrupt:
    RTI

nonmaskable:
    RTI

.goto $FFFA
.dw nonmaskable
.dw init_game
.dw interrupt
