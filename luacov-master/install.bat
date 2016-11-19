
echo @echo off > .\src\bin\luacov.bat
echo lua %LUA_LUA%\bin\luacov %%* >> .\src\bin\luacov.bat

xcopy /S /Y .\src\*	%LUA_LUA%

