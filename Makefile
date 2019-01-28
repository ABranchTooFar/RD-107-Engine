main.bin : main.asm variables.asm routines.asm macros.asm game_data.asm
	asm6 main.asm

game_data.asm : asmgen.py game_data.json
	python3 asmgen.py > game_data.asm

clean :
	rm -f main.bin game_data.asm
