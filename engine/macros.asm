.MACRO WaitForVBlank
-:
  BIT $2002
  BPL -
.ENDM

.MACRO ClearMemory
-:
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
  BNE -
.ENDM

; Latch the PPU status register and set PPU write address
.MACRO LatchPalette
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
.ENDM

.MACRO MoveAgent AgentIndex,HSpeed,VSpeed
; Load the Agent index value
  LDX #AgentIndex
; Load the horizontal speed
  LDA #HSpeed
  STA Param1
; Load the vertical speed
  LDA #VSpeed
  STA Param2
; Run sub-routine
  JSR moveAgent
.ENDM



.MACRO UpdatePlayer
  ; Load 0 for the player agent
  LDX #$00
  ; Horizontal speed
  LDA AgentHSpeed
  STA Param1
  ; Vertical speed
  LDA AgentVSpeed
  STA Param2
  JSR moveAgent
.ENDM
