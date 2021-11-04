as --32 -march=i386 bootloader.s -o bootloader.o
zig build-obj --strip -target i386-freestanding src/main.zig
ld -T linker.ld -o doofOS.bin -m elf_i386 bootloader.o main.o
