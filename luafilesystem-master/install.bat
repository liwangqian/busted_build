cd .\src
%MAKE% %PLAT%
cd ..

copy .\src\*.dll    	%LUA_BIN%

cd %BUILD_ROOT%