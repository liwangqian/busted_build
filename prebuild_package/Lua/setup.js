
function setup_lua_env(args)
{
	var LUA_HOME = ""
	var WshShell  = WScript.CreateObject ("WScript.Shell" );

	try {
		if (args.length == 0) {
			throw ("Param is invalid!")
		} else {
			LUA_HOME = args(0)
			//WScript.Echo("LUA Install Root Path:", LUA_HOME)
		}
	}catch(e) { 
		WScript.Echo("Error:", e);
		return -1;
	} 

	LUA_BIN 	= "%LUA_HOME%;%LUA_HOME%//lua//bin;" ;
	
	var WshSysEnv = WshShell.Environment ("SYSTEM" );

	WshSysEnv ("LUA_HOME" ) = LUA_HOME;

	//bin加入path 
	Path = WshSysEnv ("PATH" );
	if (Path.indexOf(LUA_BIN) == -1) {
		WshSysEnv ("PATH" ) = LUA_BIN + WshSysEnv ("PATH" );
	}
	
	//WScript.Echo ("LUA env setup finished!" );

	return 0;
}

setup_lua_env(WScript.Arguments)