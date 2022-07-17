local wezterm = require 'wezterm';
local act = wezterm.action


local success, date, stderr = wezterm.run_child_process({"date"});


-- wezterm.log_info("Hello!");
wezterm.on("window-config-reloaded", function(window, pane)
  wezterm.log_info("the config was reloaded for this window!");
end)

wezterm.on("show-font-size", function(window, pane)
  wezterm.log_error(window:effective_config().font_size);
end)

wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime("%b %-d %H:%M:%S");

  -- Make it italic and underlined
  window:set_right_status(wezterm.format({
    {Attribute={Underline="Single"}},
    {Attribute={Italic=true}},
    {Text=date},
  }));
end);

adjust_window_size_when_changing_font_size = false 


-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = {name, "JetBrains Mono"}
  return wezterm.font_with_fallback(names, params)
end



wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z] "
  end

  local index = ""
  if #tabs > 1 then
    index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)



return {
  enable_wayland = true,
  automatically_reload_config = true,
--  disable_default_key_bindings = true,
--  color_scheme = "Solarized Dark - Patched",
--  color_scheme = "seoulbones_light",
-- color_scheme = "Solarized Darcula",
  color_scheme = "Smyck",
  font_size = 18,
  font = wezterm.font_with_fallback({
	  {family = "Hack",weight="Light",},
	  {family = "JetBrains Mono", weight = "Medium",},
	  {family = "Noto Color Emoji"}
  }),
  -- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
  default_cursor_style = "SteadyBar",
  scrollback_lines = 3500,
  tab_bar_at_bottom = false,

  -- tab bar
  use_resize_increments = true,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  -- tab_max_width = 17,

  keys = {
    -- This will create a new split and run your default program inside it
    {key="d", mods="CMD",
      action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="d", mods="CMD|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
    {key="Enter", mods="CMD", action=wezterm.action.ToggleFullScreen},
    { key = "Enter", mods="CMD|SHIFT", action=wezterm.action.TogglePaneZoomState },
    {key="UpArrow", mods="SHIFT", action=act.ScrollByLine(-1)},
    {key="DownArrow", mods="SHIFT", action=act.ScrollByLine(1)},
    -- Clears only the scrollback and leaves the viewport intact.
    -- This is the default behavior.
    -- {key="k", mods="CMD", action=act.ClearScrollback("ScrollbackOnly")},
    -- Clears the scrollback and viewport leaving the prompt line the new first line.
    {key="k", mods="CMD", action=act.ClearScrollback("ScrollbackAndViewport")},

    -- closing current pane
    {key="w", mods="CMD", action=wezterm.action.CloseCurrentPane{confirm=true}},
    -- closing current tab after closing all the panes
    {key="w", mods="CMD", action=wezterm.action.CloseCurrentTab{confirm=true}},

    -- decrease font size
    {key="-", mods="CTRL", action=wezterm.action.DecreaseFontSize},
    -- increase font size
    {key="=", mods="CTRL", action=wezterm.action.IncreaseFontSize},
    
    -- tab navigator just like tmux
    {key="w", mods="CTRL", action=wezterm.action.ShowTabNavigator},

    {key="E", mods="CTRL", action=wezterm.action.EmitEvent("show-font-size")},
    {key="a", mods="CTRL", action=act.ActivatePaneByIndex(0)},
    {key="b", mods="CTRL", action=act.ActivatePaneByIndex(1)},
    {key="c", mods="CTRL", action=act.ActivatePaneByIndex(2)},
    { key = "LeftArrow", mods="CMD",
      action=act.ActivatePaneDirection("Left")},
    { key = "RightArrow", mods="CMD",
      action=act.ActivatePaneDirection("Right")},
    { key = "UpArrow", mods="CMD",
      action=act.ActivatePaneDirection("Up")},
    { key = "DownArrow", mods="CMD",
      action=act.ActivatePaneDirection("Down")},
    {key="[", mods="CTRL", action=act.ActivateTabRelativeNoWrap(-1)},
    {key="]", mods="CTRL", action=act.ActivateTabRelativeNoWrap(1)},
    {key="C", mods="CMD", action=wezterm.action.CopyTo("ClipboardAndPrimarySelection")},
    -- {key="+", mods="CMD", action=wezterm.action.DisableDefaultAssignment},

    -- paste from the clipboard
    {key="v", mods="CMD", action=act.PasteFrom("Clipboard")},

    -- paste from the primary selection
    {key="v", mods="CMD", action=act.PasteFrom("PrimarySelection")},

    -- In order for ctrl+c to work with the mac; need to disable default assignment
    {key="c", mods="CTRL", action="DisableDefaultAssignment"},
  },

  -- Inactive panes dull 
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.8,
  },

  -- Background opacity
  window_background_opacity = 1.0,
  -- Enable scroll bar
  -- Enable the scrollbar.
  -- It will occupy the right window padding space.
  -- If right padding is set to 0 then it will be increased
  -- to a single cell width
  enable_scroll_bar = true,


  colors = {
    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#1098F7",
    -- The color of the split lines between panes
    split = "#444444",
    -- Make the selection text color fully transparent.
    -- When fully transparent, the current text color will be used.
    selection_fg = "none",
    -- Set the selection background color with alpha.
    -- When selection_bg is transparent, it will be alpha blended over
    -- the current cell background color, rather than replace it
    selection_bg = "rgba(50% 50% 50% 50%)",

    -- visual_bell = "#202020",
  },

  window_padding = {
    left = 12,
    right = 22,
    top = 0,
    bottom = 0,
  },



  colors = {
    tab_bar = {
      -- The color of the inactive tab bar edge/divider
      inactive_tab_edge = "#575757",
    },
  },

mouse_bindings = {
    {
      event={Drag={streak=1, button="Left"}},
      mods="NONE",
      action=wezterm.action.StartWindowDrag
    },
    {
      event={Drag={streak=1, button="Left"}},
      mods="CTRL|SHIFT",
      action=wezterm.action.StartWindowDrag
    },
    {
      event={Up={streak=1, button="Left"}},
      mods="SHIFT",
      action=wezterm.action.ExtendSelectionToMouseCursor("Word"),
    }
  },
  native_macos_fullscreen_mode = false,

  -- When true (the default), the viewport will automatically scroll to the bottom of the scrollback when there is input to the terminal so that you can see what you are typing.
  scroll_to_bottom_on_input = true,
  selection_word_boundary = "{}[]()\"'`,;:",
  show_tab_index_in_tab_bar = true,
  show_update_window = true,
  tab_and_split_indices_are_zero_based = false,
  window_decorations = "TITLE|RESIZE",
  freetype_load_target = "Normal",

  line_height = 1.2,
  min_scroll_bar_height = "0.5cell",

}


