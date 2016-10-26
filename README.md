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
