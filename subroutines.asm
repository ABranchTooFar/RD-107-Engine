  CONTROLLER_REGISTER_1 .EQU #$4016
  CONTROLLER_REGISTER_2 .EQU #$4017

; ReadControllers
; Ring counters are used to store controller button state in the address 'Controller<N>'
; Adapted from https://wiki.nesdev.com/w/index.php/Controller_Reading
.IF NUMBER_OF_PLAYERS!=0
  ReadControllers:
    ; Set the strobe bit to get controller status
    LDA #$01
    STA CONTROLLER_REGISTER_1
    .IF NUMBER_OF_PLAYERS==1
      STA Controller1
    .ELSE
      STA Controller2
    .ENDIF
    ; Clear the strobe bit to keep the controller status steady
    LSR a                       ; A is now 0
    STA CONTROLLER_REGISTER_1   ; Clear the strobe bit
  -                             ; Loop to read the controller status
    LDA CONTROLLER_REGISTER_1
    LSR a                       ; a[0] bit -> Carry
    ROL Controller1             ; Carry -> a[0] bit and a[7] bit -> Carry
    .IF NUMBER_OF_PLAYERS==2
      LDA CONTROLLER_REGISTER_2
      LSR a                     ; a[0] bit -> Carry
      ROL Controller2           ; Carry -> a[0] bit and a[7] bit -> Carry
    .ENDIF
    BCC -
    RTS
.ENDIF



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
