# luasystem
#
# Definitions in this section can be overriden on the command line or in the
# environment.
#

# LUA_VERSION: 5.1 5.2 5.3
# lua version to build against
LUA_VERSION?=$(LUA_VER)

# MYCFLAGS: to be set by user if needed
MYCFLAGS=

# MYLDFLAGS: to be set by user if needed
MYLDFLAGS=

# LUAINC_linux:
# /usr/include/lua$(LUA_VERSION)
# /usr/local/include
# /usr/local/include/lua$(LUA_VERSION)
# where lua headers are found for linux builds
LUAINC_linux_base?=/usr/include
LUAINC_linux?=$(LUAINC_linux_base)/lua/$(LUA_VERSION)
LUAPREFIX_linux?=/usr/local
CDIR_linux?=lib/lua/$(LUA_VERSION)
LDIR_linux?=share/lua/$(LUA_VERSION)

# where lua headers are found for mingw builds
# LUAINC_mingw:
# /opt/local/include
LUAINC_mingw_base?=$(LUA_ROOT)
LUAINC_mingw?=$(LUAINC_mingw_base)/$(LUA_VERSION)/include
LUALIB_mingw_base?=$(LUA_ROOT)
LUALIB_mingw?=$(LUALIB_mingw_base)/$(LUA_VERSION)/lua$(subst .,,$(LUA_VERSION)).dll
LUAPREFIX_mingw?=$(LUA_ROOT)
CDIR_mingw?=lua/$(LUA_VERSION)
LDIR_mingw?=lua/$(LUA_VERSION)/lua


# prefix: /usr/local /usr /opt/local /sw
# the top of the default install tree
prefix?=$(LUAPREFIX_$(PLAT))

CDIR?=$(CDIR_$(PLAT))
LDIR?=$(LDIR_$(PLAT))

# DESTDIR: (no default)
# used by package managers to install into a temporary destination
DESTDIR=

#------
# Definitions below can be overridden on the make command line, but
# shouldn't have to be.


#------
# Supported platforms
#
PLATS= linux mingw

#------
# Compiler and linker settings
# for Linux
SO_linux=so
O_linux=o
CC_linux=gcc
DEF_linux=
CFLAGS_linux= -I$(LUAINC) $(DEF) -Wall -Wshadow -Wextra \
	-Wimplicit -O2 -ggdb3 -fpic -fvisibility=hidden
LDFLAGS_linux=-lrt -O -shared -fpic -o
LD_linux=gcc

#------
# Compiler and linker settings
# for MingW
SO_mingw=dll
O_mingw=o
CC_mingw=gcc
DEF_mingw=-DWINVER=0x0600 -D_WIN32_WINNT=0x0600
CFLAGS_mingw= -I$(LUAINC) $(DEF) -Wall -O2 -fno-common \
	-fvisibility=hidden
LDFLAGS_mingw= $(LUALIB) -shared -Wl,-s -o
LD_mingw=gcc


.SUFFIXES: .obj

.c.obj:
	$(CC) $(CFLAGS) //Fo"$@" //c $<

#------
# Output file names
#
SO=$(SO_$(PLAT))
O=$(O_$(PLAT))
SOLIB=core.$(SO)

#------
# Settings selected for platform
#
CC=$(CC_$(PLAT))
DEF=$(DEF_$(PLAT))
CFLAGS=$(MYCFLAGS) $(CFLAGS_$(PLAT))
LDFLAGS=$(MYLDFLAGS) $(LDFLAGS_$(PLAT))
LD=$(LD_$(PLAT))
LUAINC= $(LUAINC_$(PLAT))
LUALIB= $(LUALIB_$(PLAT))

#------
# Objects
#
OBJS=core.$(O) 

#------
# Targets
#
default: $(PLAT)

linux:
	$(MAKE) all PLAT=linux

mingw:
	$(MAKE) all PLAT=mingw

none:
	@echo "Please run"
	@echo "   make PLATFORM"
	@echo "where PLATFORM is one of these:"
	@echo "   $(PLATS)"

all: $(SOLIB)

$(SOLIB): $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS)$@

clean:
	rm -f $(SOLIB) $(OBJS)

.PHONY: all $(PLATS) default clean none
