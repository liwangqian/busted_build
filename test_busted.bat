
@echo off

set CUR_DIR=%~dp0

REM '安装路径，需要根据用户安装路径进行修改'
set INSTALL_ROOT=C:\Lua

cd /d %INSTALL_ROOT%

echo Test busted is runing...
call busted -o gtest > %CUR_DIR%\report.txt
echo Test busted is finished, see %CUR_DIR%report.txt for detail report.

pause
