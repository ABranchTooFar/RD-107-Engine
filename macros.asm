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
