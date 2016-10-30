cd .\src
mingw32-make mingw
cd ..

copy .\src\*.dll    	%LUA_BIN%

cd %BUILD_ROOT%