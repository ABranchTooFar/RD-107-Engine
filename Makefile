main.bin : main.asm gamedata.asm
	asm6 main.asm

gamedata.asm : asmgen.py gamedata.json
	python3 asmgen.py > gamedata.asm

clean :
	rm -f main.bin gamedata.asm
