
mingw32-make mingw

set SUB_SYS=term
mkdir %LUA_BIN%\%SUB_SYS% %LUA_LUA%\%SUB_SYS%

copy .\*.dll    	%LUA_BIN%\%SUB_SYS%
copy .\term\*.lua   %LUA_LUA%\%SUB_SYS%
