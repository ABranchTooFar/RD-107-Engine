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
