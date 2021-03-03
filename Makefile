all:	app-sqlite-linux-native

app-sqlite-linux-native:	libsqlite.a	main.c
	musl-gcc -c -fno-omit-frame-pointer -fno-stack-protector \
		-fno-tree-sra -fno-split-stack -O2 -fno-PIC -fhosted \
		-ffreestanding -fno-tree-loop-distribute-patterns -m64 \
		-mno-red-zone -fno-asynchronous-unwind-tables \
		-fno-reorder-blocks -mtune=generic -D_POSIX_SOURCE \
		-D_BSD_SOURCE -I./include -g3 main.c
	musl-gcc -static -O2 main.o libsqlite.a -g3 -o app-sqlite-linux-native
