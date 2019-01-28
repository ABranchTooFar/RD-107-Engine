.ENUM $0000

  Param1 .DSB 1
  Param2 .DSB 1
  Param3 .DSB 1

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
 

  AgentXHigh      .DSB AGENT_TOTAL
  AgentXLow       .DSB AGENT_TOTAL
  AgentYHigh      .DSB AGENT_TOTAL
  AgentYLow       .DSB AGENT_TOTAL
  AgentHSpeed     .DSB AGENT_TOTAL
  AgentVSpeed     .DSB AGENT_TOTAL
  AgentOAMAddress .DSB AGENT_TOTAL
  AgentTileTotal  .DSB AGENT_TOTAL



.ENDE
