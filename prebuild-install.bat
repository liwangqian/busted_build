
@echo off

REM "用户参数配置区BEG"
set INSTALL_ROOT=C:\Lua
REM "参数配置区END"

xcopy /S /Y prebuild_package\Lua\* %INSTALL_ROOT%\

cd /d %INSTALL_ROOT%

call setup_env.bat

pause
