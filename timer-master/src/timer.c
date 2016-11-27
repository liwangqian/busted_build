#include <lua.h>
#include <lauxlib.h>

#ifdef _WIN32
    #include <windows.h>
    #define EXPORT __declspec(dllexport)
#else
    #include <sys/time.h>
    #include <unistd.h>
    #define EXPORT
#endif

static int tm_msleep(lua_State *L)
{
    int ms = luaL_checkint(L, 1);
    if (ms < 0)
        return luaL_error(L, "argument must be a positive integer");
#ifdef _WIN32
    Sleep(ms);
#else
    struct timeval tv;
    tv.tv_sec = (long)ms / 1000L;
    tv.tv_usec = (long)ms % 1000L * 1000L;
    select(0, NULL, NULL, NULL, &tv);
#endif
    return 1;
}

/*-------------------------------------------------------------------------*\
* Gets time in ms, relative to system startup.
* Returns
*   time in ms.
\*-------------------------------------------------------------------------*/
#ifdef _WIN32
double tm_gettime_(void) {
    FILETIME ft;
    GetSystemTimeAsFileTime(&ft);
    return ft.dwLowDateTime/1.0e7 + ft.dwHighDateTime*(4294967296.0/1.0e7);
}
#else
double tm_gettime_(void) {
    struct timeval v;
    gettimeofday(&v, (struct timezone *) NULL);
    return v.tv_sec + v.tv_usec/1.0e6;
}
#endif

static int tm_gettime(lua_State *L)
{
    lua_pushnumber(L, tm_gettime_());
    return 1;
}

static luaL_Reg func[] = {
    { "gettime", tm_gettime },
    { "msleep",  tm_msleep  },
    { NULL, NULL }
};

/*-------------------------------------------------------------------------
 * Initializes module
 *-------------------------------------------------------------------------*/
EXPORT int luaopen_timer(lua_State *L) {
    luaL_register(L, "timer", func);
	return 0;
}
