;;;
;;; Main program for UltiConfig
;;;
;;; September 2020 ops
;;;
;;; Last modification January 2021
;;;

        .include "cbm_kernal.inc"
        .include "vic20.inc"
        .include "ultimem.inc"
        .include "version.inc"

READY     := $C474
PRNTCRLF  := $CAD7
PTRSTR    := $CB1E        ; Print zero terminated string
INITBA    := $E3A4
INITVCTRS := $E45B
FREMSG    := $E404
INITSK    := $E518
INITMEM   := $FD8D
FRESTOR   := $FD52
INITVIA   := $FDF9

PTR1       = $FA
PTR2       = $FC
TMP1       = $FE

KEY_F1     = $85
KEY_F3     = $86
KEY_F5     = $87
KEY_F7     = $88
KEY_F2     = $89
KEY_F4     = $8A
KEY_F6     = $8B
KEY_F8     = $8C
KEY_ENTER  = $0D

RVS_ON     = $12
RVS_OFF    = $92

COL_RED    = 28
COL_BLUE   = 31
COL_BLACK  = 144
COL_YELLOW = 158
COL_CYAN   = 159

PETSCII_CR = 13
PETSCII_CRSR_UP = 145
PETSCII_CRSR_RIGHT = 29
PETSCII_CRSR_LEFT = 157
PETSCII_CRSR_DOWN = 17
PETSCII_INSERT = 148
PETSCII_DEL = 20
PETSCII_QUOTE = 34

        .export __LOADADDR__: absolute = 1
        .segment "LOADADDR"
        .addr   *+2

        .import miniwedge_install
        .import miniwedge_uninstall
        .import miniwedge_banner
        .import fkey_install
        .import fkey_uninstall

        .import sj20_init
        .import eload_load

        .import __IO23_BANK2_CODE_LOAD__
        .import __IO23_BANK2_START__
        .import __IO23_BANK2_LAST__
        .import __IO23_BANK6_CODE_LOAD__
        .import __IO23_BANK6_START__
        .import __IO23_BANK6_LAST__

        ; Used by ELoad+
        ptr1 = $ae
        .export ptr1

        .export keydef_f1
        .export keydef_f2
        .export keydef_f3
        .export keydef_f4
        .export keydef_f5
        .export keydef_f6
        .export keydef_f7
        .export keydef_f8

        .segment "MENUCODE"

        jmp     main

banner: .byte 14,RVS_ON,COL_BLUE
        .byte 176,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,174
        .byte 221,COL_RED,"     ULTICONFIG     ",COL_BLUE,221
        .byte 173,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,189
        .byte 13,13,COL_BLUE

        .byte "  ",176,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,174,13
        .byte "  ",221,"    Select      ",221,13
        .byte "  ",221," Configuration: ",221,13
        .byte "  ",171,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,179,13
        .byte "  ",221,"                ",221,13

        .byte "  ",221," ",COL_RED,182,RVS_ON,"F1",RVS_OFF,161,COL_BLACK,"RAM123 [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F2",RVS_OFF,161,COL_BLACK,"BLK1   [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F3",RVS_OFF,161,COL_BLACK,"BLK2   [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F4",RVS_OFF,161,COL_BLACK,"BLK3   [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F5",RVS_OFF,161,COL_BLACK,"BLK5   [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F6",RVS_OFF,161,COL_BLACK,"I/O23  [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F7",RVS_OFF,161,COL_BLACK,"Wedge  [ ] ",COL_BLUE,221,13
        .byte "  ",221," ",COL_RED,182,RVS_ON,"F8",RVS_OFF,161,COL_BLACK
        .ifdef ELOAD
          .byte "ELoad+"
        .else
          .byte "SJ20  "
        .endif
        .byte " [ ] ",COL_BLUE,221,13
        .byte "  ",221,"                ",221,13

        .byte "  ",171,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,179,13
        .byte "  ",221," Press ",COL_RED, 182,RVS_ON, "RETURN", RVS_OFF,161,COL_BLUE," ",221,13
        .byte "  ",221," to reboot.     ",221,13
        .byte "  ",173,192,192,192,192,192,192,192,192,192,192,192,192
        .byte ULTICONFIG_VERSION_MAJOR,".",ULTICONFIG_VERSION_MINOR
        .ifdef ULTICONFIG_NTSC
          .byte "N"
        .else
          .byte "P"
        .endif
        .byte 189
        .byte COL_RED,0

main:
        sei
        lda     $9F55           ; Re-enable the UltiMem registers
        lda     $9FAA           ; if they were disabled previously.
        lda     $9F01

        lda     #ULTIMEM_LED_MASK
        sta     ULTIMEM_CONTROL

        lda     #<$0000
        ldx     #>$0000
        sta     ULTIMEM_BLK5_BANK
        stx     ULTIMEM_BLK5_BANK+1

        lda     #<$0001
        ldx     #>$0001
        sta     ULTIMEM_RAM_BANK
        stx     ULTIMEM_RAM_BANK+1

        lda     #<$0003
        ldx     #>$0003
        sta     ULTIMEM_BLK1_BANK
        stx     ULTIMEM_BLK1_BANK+1

        lda     #<$0004
        ldx     #>$0004
        sta     ULTIMEM_BLK2_BANK
        stx     ULTIMEM_BLK2_BANK+1

        lda     #<$0005
        ldx     #>$0005
        sta     ULTIMEM_BLK3_BANK
        stx     ULTIMEM_BLK3_BANK+1

        lda     #ULTIMEM_IO2_RAM_RW | ULTIMEM_IO3_RAM_RW
        sta     ULTIMEM_MEM_CONFIG1

        .ifdef ELOAD
        lda     #<$0006
        ldx     #>$0006
        sta     ULTIMEM_IO_BANK
        stx     ULTIMEM_IO_BANK+1

        ; Source pointer
        lda     #<__IO23_BANK6_CODE_LOAD__
        sta     PTR1
        lda     #>__IO23_BANK6_CODE_LOAD__
        sta     PTR1+1
        ; Size
        ldx     #<~(__IO23_BANK6_LAST__-__IO23_BANK6_START__)
        lda     #>~(__IO23_BANK6_LAST__-__IO23_BANK6_START__)
        sta     TMP1
        jsr     copy_data
        .endif ; ELOAD

        lda     #<$0002
        ldx     #>$0002
        sta     ULTIMEM_IO_BANK
        stx     ULTIMEM_IO_BANK+1

        ; Source pointer
        lda     #<__IO23_BANK2_CODE_LOAD__
        sta     PTR1
        lda     #>__IO23_BANK2_CODE_LOAD__
        sta     PTR1+1
        ; Size
        ldx     #<~(__IO23_BANK2_LAST__-__IO23_BANK2_START__)
        lda     #>~(__IO23_BANK2_LAST__-__IO23_BANK2_START__)
        sta     TMP1
        jsr     copy_data

        jsr     FRESTOR                 ; restore default I/O vectors
        jsr     INITVIA                 ; initialise I/O registers
        jsr     INITSK                  ; initialise hardware

        lda     #<banner
        ldy     #>banner
        jsr     print_string

mainloop:
        jsr     print_config
        jsr     GETIN
        cmp     #KEY_F1
        bne     :+
        ldx     #0
        jsr     invert_selection
        jmp     mainloop
:       cmp     #KEY_F2
        bne     :+
        ldx     #1
        jsr     invert_selection
        jmp     mainloop
:       cmp     #KEY_F3
        bne     :+
        ldx     #2
        jsr     invert_selection
        jmp     mainloop
:       cmp     #KEY_F4
        bne     :+
        ldx     #3
        jsr     invert_selection
        jmp     mainloop
:       cmp     #KEY_F5
        bne     :+
        ldx     #4
        jsr     invert_selection
        jmp     mainloop
:       cmp     #KEY_F6
        bne     :+
        ldx     #5
        jsr     invert_selection
        beq     mainloop
        lda     #$00
        sta     config+6
        sta     config+7
        jmp     mainloop
:       cmp     #KEY_F7
        bne     :+
        ldx     #6
        jsr     invert_selection
        beq     mainloop
        lda     #$00
        sta     config+5
        jmp     mainloop
:       cmp     #KEY_F8
        bne     :+
        ldx     #7
        jsr     invert_selection
        beq     mainloop
        lda     #$00
        sta     config+5
        jmp     mainloop
:       cmp     #KEY_ENTER
        beq     :+
        jmp     mainloop

:       lda     #$00
        ldx     config
        beq     :+
        ora     #ULTIMEM_RAM123_RAM_RW
:       ldx     config+5
        beq     :+
        ora     #ULTIMEM_IO2_RAM_RW | ULTIMEM_IO3_RAM_RW
        .byte   $2C
:       ora     #ULTIMEM_IO2_RAM_RO | ULTIMEM_IO3_RAM_RO
        sta     ULTIMEM_MEM_CONFIG1

        lda     #$00
        ldx     config+1
        beq     :+
        ora     #ULTIMEM_BLK1_RAM_RW
:       ldx     config+2
        beq     :+
        ora     #ULTIMEM_BLK2_RAM_RW
:       ldx     config+3
        beq     :+
        ora     #ULTIMEM_BLK3_RAM_RW
:       ldx     config+4
        beq     :+
        ora     #ULTIMEM_BLK5_RAM_RW
:       sta     ULTIMEM_MEM_CONFIG2

        lda     #$00
        sta     ULTIMEM_CONTROL

        ; Perform full reset
        sei
        jsr     INITMEM                 ; initialise and test RAM
        jsr     FRESTOR                 ; restore default I/O vectors
        jsr     INITVIA                 ; initialise I/O registers
        jsr     INITSK                  ; initialise hardware
        jsr     INITVCTRS               ; initialise BASIC vector table
        jsr     INITBA                  ; initialise BASIC RAM locations
        jsr     FREMSG

        ldx     config+7
        beq     :+
        .ifdef ELOAD
        jsr     eload_init
        .else
        jsr     sj20_init
        .endif
:       ldx     config+6
        beq     :+
        jsr     miniwedge_install
        lda     #8
        sta     DEVNUM
        jsr     PRNTCRLF
        lda     #<miniwedge_banner
        ldy     #>miniwedge_banner
        jsr     PTRSTR
        jsr     fkey_install
:       ldx     #$FB
        txs
        jmp     READY


.proc invert_selection
        lda     config,x
        eor     #$01
        sta     config,x
        rts
.endproc


.proc print_config
        ldy     #$07
@loop:  tya
        pha
        jsr     set_cursor
        pla
        tay
        lda     #'X'
        ldx     config,y
        bne     :+
        lda     #' '
:       jsr     CHROUT
        dey
        bpl     @loop
        rts
.endproc


.proc set_cursor
        clc
        adc     #10
        tax
        ldy     #16
        jmp     PLOT
.endproc


.proc print_string
        sta     PTR1
        sty     PTR1+1
        ldy     #$00
:       lda     (PTR1),y
        beq     @out
        jsr     CHROUT
        iny
        bne     :-
        inc     PTR1+1
        bne     :-
@out:   rts
.endproc


.proc copy_data
        lda     #<$9800                 ; Target pointer
        sta     PTR2
        lda     #>$9800
        sta     PTR2+1

        ldy     #$00

; Copy loop
@L1:    inx
        beq     @L3
@L2:    lda     (PTR1),y
        sta     (PTR2),y
        iny
        bne     @L1
        inc     PTR1+1
        inc     PTR2+1                  ; Bump pointers
        bne     @L1                     ; Branch always (hopefully)
; Bump the high counter byte
@L3:    inc     TMP1
        bne     @L2
; Done
        rts
.endproc

config:
        .byte 0,1,1,0,0,0,1,1


;------------------------------------------------------------------------------


        .segment "IO23_BANK2_CODE"

        jsr     fkey_install
        jsr     miniwedge_install
        lda     #<miniwedge_banner
        ldy     #>miniwedge_banner
        jsr     PTRSTR
        .ifdef ELOAD
        jsr     eload_init
        .else
        jsr     sj20_init
        .endif
        rts

        .ifdef ELOAD
eload_init:
        lda     #<do_eload_load
        sta     $0330
        lda     #>do_eload_load
        sta     $0331
        rts

do_eload_load:
        pha

        sei
        jsr     miniwedge_uninstall
        jsr     fkey_uninstall

        lda     ULTIMEM_MEM_CONFIG1
        ora     #ULTIMEM_IO2_RAM_RW | ULTIMEM_IO3_RAM_RW
        sta     ULTIMEM_MEM_CONFIG1

        lda     #<$0006
        sta     ULTIMEM_IO_BANK

        .byte $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea

        lda     ULTIMEM_MEM_CONFIG1
        and     #%00101011
        sta     ULTIMEM_MEM_CONFIG1

        pla
        plp
        rts

        .endif ; ELOAD


keydef_f1:
        .byte PETSCII_CR,PETSCII_CRSR_UP,PETSCII_CRSR_UP,"@    ",PETSCII_CRSR_RIGHT,PETSCII_INSERT,PETSCII_INSERT,PETSCII_INSERT,"cd:",255
        .byte 0
keydef_f2:
        .byte 0
keydef_f3:
        .byte PETSCII_CR,PETSCII_CRSR_UP,PETSCII_CRSR_UP,"load "
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_DEL,PETSCII_DEL,PETSCII_DEL
        .byte ",8",255
        .byte 0
keydef_f4:
        .byte PETSCII_CR,PETSCII_CRSR_UP,PETSCII_CRSR_UP,"load "
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT,PETSCII_CRSR_RIGHT
        .byte PETSCII_DEL,PETSCII_DEL,PETSCII_DEL
        .byte ",8,1",255
        .byte 0
keydef_f5:
        .byte "@",PETSCII_QUOTE,"cd",95,PETSCII_QUOTE,255
        .byte 0
keydef_f6:
        .byte "@",PETSCII_QUOTE,"cd//",PETSCII_QUOTE,255
        .byte 0
keydef_f7:
        .byte 147, "$",255
        .byte 0
keydef_f8:
        .byte 0


;------------------------------------------------------------------------------


        .ifdef ELOAD

        .segment "IO23_BANK6_CODE"

        .byte $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
        .byte $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18

        pla
        jsr     eload_load
        php
        pha
        lda     #<$0002
        sta     ULTIMEM_IO_BANK

        .endif ; ELOAD
