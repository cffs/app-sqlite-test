all:	app-sqlite-linux-native

app-sqlite-linux-native:	libsqlite.a	main.c
	musl-gcc -c -fno-omit-frame-pointer -fno-stack-protector \
		-fno-tree-sra -fno-split-stack -O2 -fno-PIC -I. -g3 \
		-I./include main.c
	musl-gcc -static main.o libsqlite.a -g3 -o app-sqlite-linux-native
