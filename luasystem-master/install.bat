
cd .\src
%MAKE% %PLAT%
cd ..

set SUB_SYS=system

mkdir %LUA_BIN%\%SUB_SYS% %LUA_LUA%\%SUB_SYS%

copy .\src\*.dll    %LUA_BIN%\%SUB_SYS%
copy .\system\*.lua %LUA_LUA%\%SUB_SYS%

xcopy /S /Y .\spec\*	%LUA_SPEC%
