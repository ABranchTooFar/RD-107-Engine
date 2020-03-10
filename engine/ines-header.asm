; iNES Header
  .DB "NES", $1a ;identification of the iNES header
  .DB PRG_COUNT ;number of 16KB PRG-ROM pages
  .DB $01 ;number of 8KB CHR-ROM pages
  .DB $00|MIRRORING ;mapper 0 and mirroring
  .DSB 9, $00 ;clear the remaining bytes
