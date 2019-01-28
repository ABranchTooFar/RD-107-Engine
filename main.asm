; Constants
PRG_COUNT = 1 ;1 = 16KB, 2 = 32KB
MIRRORING = %0001 ;%0000 = horizontal, %0001 = vertical, %1000 = four-screen

; Variables
  .INCLUDE "variables.asm"

; Macros
  .INCLUDE "game_data.asm"

; iNES Header
  .DB "NES", $1a ;identification of the iNES header
  .DB PRG_COUNT ;number of 16KB PRG-ROM pages
  .DB $01 ;number of 8KB CHR-ROM pages
  .DB $00|MIRRORING ;mapper 0 and mirroring
  .DSB 9, $00 ;clear the remaining bytes

; Program Bank(s)
  .BASE $10000-(PRG_COUNT*$4000)

; Routines
  .INCLUDE "routines.asm"

Reset:

  ; TODO: Need to enable sprites and wait for the NES to be ready etc...
  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs

vblankwait1:       ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE clrmem

vblankwait2:      ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2

  ; TODO: Move this to the asmgen.py!
LoadPalettes:
  LDA $2002    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006    ; write the low byte of $3F00 address
  LDX #$00
; --------
  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDA #$22
  STA $2007             ;write to PPU
  LDA #$16
  STA $2007             ;write to PPU
  LDA #$27
  STA $2007             ;write to PPU
  LDA #$18
  STA $2007             ;write to PPU

  LDX #$00
  loadPlayer
  LDX #$04
  loadGoomba

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000

  LDA #%00010000   ; no intensify (black background), enable sprites
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop


NMI:

  LDX #$00
  LDA #$01
  STA Param1
  STA Param2
  JSR moveAgent
  LDX #$01
  LDA #$FF
  STA Param1
  LDA #$00
  STA Param2
  JSR moveAgent

  ; NOTE: NMI code goes here
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  RTI

IRQ:

  ; NOTE: IRQ code goes here
  RTI

; Interrupt Vectors
   .ORG $fffa

   .DW NMI
   .DW Reset
   .DW IRQ

; CHR-ROM Bank
   .INCBIN "tiles.chr"
