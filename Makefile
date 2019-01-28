main.bin : main.asm variables.asm routines.asm macros.asm build/macros.asm
	asm6 main.asm

build/macros.asm : asmgen.py game_data.json
	python3 asmgen.py

clean :
	rm -f main.bin build/*
