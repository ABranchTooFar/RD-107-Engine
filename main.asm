; Includes the core components of the engine
  .INCLUDE "engine/includes.asm"

; iNES Header
  .INCLUDE "engine/ines-header.asm"

; Program Bank(s)
  .BASE $10000-(PRG_COUNT*$4000)

; Sub-routines
  .INCLUDE "engine/subroutines.asm"

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

  WaitForVBlank

  ClearMemory

  WaitForVBlank

  latchPalette
  loadPalette1
  loadPalette1
  loadPalette1
  loadPalette1
  loadPalette1
  loadPalette2
  loadPalette1
  loadPalette1

  LDX #$00
  loadPlayer
  LDX #$04
  loadGoomba

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000

  LDA #%00010000   ; no intensify (black background), enable sprites
  STA $2001

Forever:

  ; Check if the NEW_FRAME flag is set
  LDA NEW_FRAME
  BIT GameState
  BEQ +skipall



  ; Skip friction if the player hspeed is 0
  LDA AgentHSpeed
  BEQ +
  ; Apply friction and skip the button checks
  ; if neither the left or right is pressed
  LDA #%00000011
  BIT Controller1
  BNE +
  ; Apply friction
  LDA AgentHSpeed
  BMI negspeed
  SEC
  SBC #$01
  STA AgentHSpeed
  ; Skip the left/right button checks
  JMP ++
negspeed
  CLC
  ADC #$01
  STA AgentHSpeed
  ; Skip the left/right button checks
  JMP ++
+
  ; Check if right is pressed
  LDA #%00000001
  BIT Controller1
  BEQ +
  ; Check if the speed is maxed
  LDX AgentHSpeed
  CPX #$03
  BPL +
  ; Add to the horizontal speed
  INX
  STX AgentHSpeed
  ;MoveAgent #$00,#$01,#$00
+
  ; Check if left is pressed
  LDA #%00000010
  BIT Controller1
  BEQ +
  ; Check if the speed is maxed
  LDX AgentHSpeed
  CPX #$FD
  BMI +
  DEX
  STX AgentHSpeed
  ;MoveAgent #$00,#$FF,#$00
+
++

  ; Set the NEW_FRAME flag to zero
  ; TODO: Fix this
  LDA #$00
  STA GameState

+skipall:
  JMP Forever     ;jump back to Forever, infinite loop


NMI:

  ; Read the controller state
  JSR ReadControllers

  ; Move the Goomba for testing
  MoveAgent #$01,#$FF,#$00

  ; Down
  LDA #%00000100
  BIT Controller1
  BEQ +
  MoveAgent #$00,#$00,#$01
+
  ; Up
  LDA #%00001000
  BIT Controller1
  BEQ +
  MoveAgent #$00,#$00,#$FF
+

  ; TODO: Make this more general?
  UpdatePlayer

  ; NOTE: NMI code goes here
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  ; Set the NEW_FRAME flag
  ; TODO: Fix this
  LDA #$01
  STA GameState

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
