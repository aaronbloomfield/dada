FLAGS	= -m64 -fno-stack-protector -Wno-unused-result -fomit-frame-pointer -O
full:
	gcc $(FLAGS) -ggdb -o overflow.exe overflow.c
	gcc $(FLAGS) -S -masm=intel -o overflow.s overflow.c
	source-highlight -d *.c *.s
