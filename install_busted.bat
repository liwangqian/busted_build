
@echo off

REM "用户参数配置区BEG"
set LUA_VER=5.1
set LUA_ROOT=E:\Lua
REM "参数配置区END"

set LUA_BIN=%LUA_ROOT%\%LUA_VER%
set LUA_LUA=%LUA_ROOT%\%LUA_VER%\lua
set LUA_INC=%LUA_ROOT%\%LUA_VER%\include
set LUA_LIB=%LUA_ROOT%\%LUA_VER%\libs

REM "busted 测试用例安装路径"
set LUA_SPEC=%LUA_ROOT%\spec\

REM "创建安装目录"
rd /s /q %LUA_ROOT%
mkdir %LUA_SPEC% %LUA_BIN% %LUA_LIB% %LUA_INC% %LUA_LUA%

set BUILD_ROOT=%~dp0

REM "先安装LUA开发环境"
echo ======== install: lua%LUA_VER%
cd %BUILD_ROOT%\lua%LUA_VER%
call install.bat
cd %BUILD_ROOT%

REM "安装其他模块"
@echo off
for /f "delims=" %%i in (' dir /ad /b ') do (
	if NOT "%%i" == "lua%LUA_VER%" (
		echo ======== install: %%i
		cd %BUILD_ROOT%\%%i
		call install.bat
		cd %BUILD_ROOT%
	)
)

pause
