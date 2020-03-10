sample : main.asm macros $(shell find engine -type f)
	asm6 main.asm build/sample.nes

macros : engine/asmgen/asmgen.py game_data.json
	python3 engine/asmgen/asmgen.py

clean :
	rm -f build/*
