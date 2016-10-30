

mkdir %LUA_LUA%\busted
xcopy /S /Y .\busted\*	%LUA_LUA%\busted

echo lua %LUA_LUA%\bin\busted %%* > .\bin\busted.bat

mkdir %LUA_LUA%\bin
copy .\bin\* 			%LUA_LUA%\bin

xcopy /S /Y .\spec\*	%LUA_SPEC%