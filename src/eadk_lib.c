#include "eadk_lib.h"
#include <lualib.h>
#include <lauxlib.h>
#include <eadk.h>

static int timing_msleep(lua_State * L) {
  int ms = luaL_checknumber(L, 1);
  eadk_timing_msleep(ms);
  return 0; // Number of returned values
}

void eadk_display_draw_string(const char * text, eadk_point_t point, bool large_font, eadk_color_t text_color, eadk_color_t background_color);

static int display_draw_string(lua_State * L) {
  const char * text = luaL_checklstring(L, 1, NULL);
  uint16_t x = luaL_checknumber(L, 2);
  uint16_t y = luaL_checknumber(L, 3);
  bool large_font = luaL_optinteger(L, 4, true);
  eadk_color_t text_color = luaL_optinteger(L, 5, eadk_color_black);
  eadk_color_t background_color = luaL_optinteger(L, 6, eadk_color_white);

  eadk_display_draw_string(text, (eadk_point_t){x, y}, large_font, text_color, background_color);

  return 0; // Number of returned values
}

static const struct luaL_Reg eadk_lib[] = {
  {"display_draw_string", display_draw_string},
  {"timing_msleep", timing_msleep},
  {NULL, NULL}
};

void load_eadk_lib(lua_State * L){
  luaL_newlib(L, eadk_lib);
  lua_setglobal(L, "eadk");
}
