main.bin : main.asm engine/variables.asm engine/subroutines.asm engine/macros.asm build/macros.asm
	asm6 main.asm sample.nes

build/macros.asm : asmgen.py game_data.json
	python3 asmgen.py

clean :
	rm -f *.bin *.nes build/*
