main.bin : main.asm engine/variables.asm engine/subroutines.asm engine/macros.asm build/macros.asm
	asm6 main.asm sample.nes

build/macros.asm : engine/asmgen/asmgen.py game_data.json
	python3 engine/asmgen/asmgen.py

clean :
	rm -f *.bin *.nes build/*
