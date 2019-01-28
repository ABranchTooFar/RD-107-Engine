.MACRO MoveAgent x,h,v
; Load the Agent index value
  LDX #x
; Load the horizontal speed
  LDA #h
  STA Param1
; Load the vertical speed
  LDA #v
  STA Param2
; Run sub-routine
  JSR moveAgent
.ENDM
