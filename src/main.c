#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <eadk.h>
#include "eadk_lib.h"

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = "Lua";
const uint32_t eadk_api_level  __attribute__((section(".rodata.eadk_api_level"))) = 0;

// TODO: Check why __exidx_start/__exidx_end is needed
void __exidx_start() { }
void __exidx_end() { }

int main(int argc, char ** argv) {
  lua_State * L = luaL_newstate();
  luaL_openlibs(L);
  load_eadk_lib(L);

  char * code = eadk_external_data;

  if (luaL_loadstring(L, code) == LUA_OK) {
    if (lua_pcall(L, 0, 0, 0) == LUA_OK) {
      lua_pop(L, lua_gettop(L));
    } else {
      printf("ERR: %s\n", lua_tostring(L,-1));
      eadk_timing_msleep(1000);
    }
  }

  lua_close(L);
  return 0;
}
