moveAgent:
; Calculates the last tile address in the OAM
  LDA AgentOAMAddress, x
  STA Param3
  LDA AgentTileTotal, x
  ASL
  ASL
  CLC
  ADC Param3
  TAX
-

  DEX

; Modifies x-position of the tile
  LDA $0200, x
  CLC
  ADC Param1
  STA $0200, x
  CPX Param1

  DEX
  DEX
  DEX

; Modifies y-position of the tile
  LDA $0200, x
  CLC
  ADC Param2
  STA $0200, x

; Loops through tiles until first tile
  CPX Param3
  BNE -
  RTS
