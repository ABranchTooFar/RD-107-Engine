OBJECT_TOTAL .EQU 8


.ENUM $0000

  Param1 .DSB 1
  Param2 .DSB 1
  Param3 .DSB 1

  NUMBER_OF_PLAYERS .EQU 1

  .IF NUMBER_OF_PLAYERS!=0
    Controller1 .DSB 1
    .IF NUMBER_OF_PLAYERS>1
      Controller2 .DSB 1
    .ENDIF
    .IF NUMBER_OF_PLAYERS>2
      Controller3 .DSB 1
    .ENDIF
    .IF NUMBER_OF_PLAYERS>3
      Controller4 .DSB 1
    .ENDIF
  .ENDIF
 

  AgentXHigh      .DSB OBJECT_TOTAL
  AgentXLow       .DSB OBJECT_TOTAL
  AgentYHigh      .DSB OBJECT_TOTAL
  AgentYLow       .DSB OBJECT_TOTAL
  AgentHSpeed     .DSB OBJECT_TOTAL
  AgentVSpeed     .DSB OBJECT_TOTAL
  AgentOAMAddress .DSB OBJECT_TOTAL
  AgentTileTotal  .DSB OBJECT_TOTAL



.ENDE
