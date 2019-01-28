OBJECT_TOTAL .EQU 8


.ENUM $0000

  Param1 .DSB 1
  Param2 .DSB 1
  Param3 .DSB 1


  AgentXHigh      .DSB OBJECT_TOTAL
  AgentXLow       .DSB OBJECT_TOTAL
  AgentYHigh      .DSB OBJECT_TOTAL
  AgentYLow       .DSB OBJECT_TOTAL
  AgentHSpeed     .DSB OBJECT_TOTAL
  AgentVSpeed     .DSB OBJECT_TOTAL
  AgentOAMAddress .DSB OBJECT_TOTAL
  AgentTileTotal  .DSB OBJECT_TOTAL



.ENDE
