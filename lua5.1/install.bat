
cd .\src
%MAKE% %PLAT%
cd ..

copy .\src\*.exe	%LUA_BIN%
copy .\src\*.dll    %LUA_BIN%
copy .\src\lua*.dll %LUA_BIN%\lua%LUA_VER%.dll

copy .\src\lua*.h   	%LUA_INC%
copy .\src\lauxlib.h   	%LUA_INC%
copy .\etc\lua.hpp  	%LUA_INC%

copy .\src\*.a		%LUA_LIB%
copy .\src\*.dll	%LUA_LIB%
copy .\src\lua*.dll %LUA_LIB%\lua%LUA_VER%.dll

setup.js %LUA_ROOT%\%LUA_VER%