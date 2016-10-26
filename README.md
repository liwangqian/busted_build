# busted_build
busted install guide for linux and windows manually


#1. install LuaFilesystem:

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/lfs.c -o src/lfs.o

gcc -shared -o lfs.so -L/usr/local/lib src/lfs.o

cp lfs.so /usr/local/share/lua/5.1/

#2. install lua-term:

gcc -O2 -fPIC -I/usr/include/lua5.1 -c core.c -o core.o

gcc -shared -o term/core.so -L/usr/local/lib core.o

mkdir /usr/local/share/lua/5.1/term

cp term/core.so /usr/local/share/lua/5.1/term/

#3. install luasystem:

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/core.c -o src/core.o

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/compat.c -o src/compat.o

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/time.c -o src/time.o

gcc -shared -o system/core.so -L/usr/local/lib src/core.o src/compat.o src/time.o -lrt

mkdir /usr/local/share/lua/5.1/system

cp system/core.so /usr/local/share/lua/5.1/system/


#4. install yaml:

lub 1.1.0-1 is now built and installed in /usr/local/ (license: MIT)

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/api.c -o src/api.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/b64.c -o src/b64.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/dumper.c -o src/dumper.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/emitter.c -o src/emitter.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/loader.c -o src/loader.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/lyaml.c -o src/lyaml.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/parser.c -o src/parser.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/reader.c -o src/reader.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/scanner.c -o src/scanner.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/strtod.c -o src/strtod.o -Isrc

gcc -O2 -fPIC -I/usr/include/lua5.1 -c src/writer.c -o src/writer.o -Isrc

gcc -shared -o yaml/core.so -L/usr/local/lib src/api.o src/b64.o src/dumper.o src/emitter.o src/loader.o src/lyaml.o src/parser.o src/reader.o src/scanner.o src/strtod.o src/writer.o
