
@echo off

REM "用户参数配置区BEG"
set INSTALL_ROOT=C:\Lua
REM "参数配置区END"

xcopy /S /Y prebuild_package\Lua\* %INSTALL_ROOT%\

cd /d %INSTALL_ROOT%

REM "拷贝busted测试用例的配置文件"
copy %~dp0.busted %INSTALL_ROOT%

call setup_env.bat

echo lua %INSTALL_ROOT%\5.1\lua\bin\busted %%* > %INSTALL_ROOT%\5.1\lua\bin\busted.bat
echo lua %INSTALL_ROOT%\5.1\lua\bin\luacov %%* > %INSTALL_ROOT%\5.1\lua\bin\luacov.bat

pause
