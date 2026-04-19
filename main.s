.include "registers.s"
.include "const.s"
.include "vars.s"

.segment "HEADER"
  ; .byte "NES", $1A      ; iNES header identifier
  .byte $4E, $45, $53, $1A
  .byte 2               ; 2x 16KB PRG code
  .byte 1               ; 1x  8KB CHR data
  .byte $00, $00        ; mapper 0, horizontal mirroring

.segment "VECTORS"
  ;; When an NMI happens (once per frame if enabled) the label nmi:
  .addr nmi
  ;; When the processor first turns on or is reset, it will jump to the label reset:
  .addr reset
  ;; External interrupt IRQ (unused)
  .addr irq

; "nes" linker config requires a STARTUP section, even if it's empty
.segment "STARTUP"

; Main code segment for the program
.segment "CODE"

reset:
    sei		; disable IRQs
    cld		; disable decimal mode
    ldx #$40
    stx JOYPAD2	; disable APU frame IRQ
    ldx #$ff 	; Set up stack
    txs		;  .
    inx		; now X = 0
    stx PPUCTRL	; disable NMI
    stx PPUMASK 	; disable rendering
    stx DMC_FREQ 	; disable DMC IRQs

;; first wait for vblank to make sure PPU is ready
vblankwait1:
    bit PPUSTATUS
    bpl vblankwait1

clear_memory:
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne clear_memory

;; second wait for vblank, PPU is ready after this
vblankwait2:
    bit PPUSTATUS
    bpl vblankwait2

load_palettes:
    bit PPUSTATUS ; clear w register by reading Status
    lda #$3f
    sta PPUADDR
    lda #$00
    sta PPUADDR

    ldx #$00
    @loop:
        lda palettes, x
        sta PPUDATA
        inx
        cpx #$20
        bne @loop

load_initial_sprites:
    ldx #$00
    @loop:
        lda sprites, x
        sta OAM, x         ; Load the sprites into OAM
        inx
        cpx #SpriteLastByte
        bne @loop
    ; inc dmaflag

set_scroll:
    lda #$00
    sta xscroll
    sta yscroll
    ; inc ppuflag

enable_rendering:
    lda #%10001000	; Enable NMI, sprite tile 1, horizontal increment
    sta PPUCTRL
    sta softPPUCTRL
    lda #%00011110	; Enable Sprites and Background
    sta PPUMASK
    sta softPPUMASK
    ; inc drawflag

initial_variables:
    lda #InitialState
    sta currentState
    lda #InitialCenter
    sta currentCenter
    asl ; x2 
    sta currentMapColumn

    ldx #0
load_map:
    lda MAP_ROM, x
    sta MAP, x
    inx 
    bne load_map

    stx nmiflag ; zero the NMI flag
    cli         ; enable interrupts

main_loop:
    lda nmiflag
    beq main_loop   ; wait for nmi_flag

    jsr readjoyx2   ; read two gamepads

    stateMachine:
        lda currentState
        asl ; x2 
        tax
        lda StateJumpTable, x        ; Low byte
        sta tempAddr
        lda StateJumpTable+1, x      ; High byte
        sta tempAddr+1
        jmp (tempAddr)          ; Jump to the handler
    stateMachineEnd:

    lda drawflag
    beq :+ ; draw only when flag set
        jsr PrepareDrawing
        ; jsr PrepareDrawingTest
        jsr PrepareColors
    :

    ; lda currentRenderColumn
    lda currentDrawingColumn
    ; clc
    ; adc #1                      ; add 1
    and #%1111                  ; wrap around 0-15
    sta currentRenderColumn     ; save
    ; sta currentDrawingColumn
    and #%1000                  ; check nametable
    lsr a                       ; 8 >> 1 = 4
    clc
    adc #$20                     ; nametable0 = $20, nametable1 = $24
    sta currentRenderNametableAddress

    lda #1
    sta ppuflag
    ; sta drawflag
    sta dmaflag

    lda dmcIRQenable
    bne skipSpriteCheck

        vblankLoop:
            bit PPUSTATUS  ; check for sprite 0 clear
            bvs vblankLoop ; loop if still set (still in previous vBlank)

        sprite0loop:
            bit PPUSTATUS   ; check for sprite 0 set
            bmi skipSpriteCheck
            bvc sprite0loop ; loop if still clear

            lda #0
            sta PPUSCROLL
            lda #%10001000
            sta PPUCTRL
            bit PPUSTATUS

    skipSpriteCheck:
        lda #0
        sta nmiflag
        jmp main_loop

.include "statemachine.s"
.include "joypad.s"
.include "drawing.s"

MusicEngine:
    rts

.include "nmi.s"

irq:
    rti

.include "maps.s"
.include "sprites.s"
.include "palettes.s"

; Character memory
.segment "CHARS"
    .incbin "famitower.chr", 0, 8192
