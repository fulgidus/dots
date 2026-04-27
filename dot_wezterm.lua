local wez = require("wezterm")
local conf = wez.config_builder()

-- General
conf.line_height = 1.0
conf.font = wez.font("FiraCode Nerd Font Mono")
conf.font_size = 11.0
conf.window_background_opacity = 0.8
conf.color_scheme = "Tokyo Night"
conf.default_cursor_style = "SteadyUnderline"
conf.scrollback_lines = 10000
conf.prefer_egl = true
conf.max_fps = 60


-- Copy to clipboard on mouse select
conf.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wez.action.CompleteSelectionOrOpenLinkAtMouseCursor "ClipboardAndPrimarySelection",
    },
}

conf.window_decorations = "TITLE | RESIZE"
conf.enable_tab_bar = false
conf.window_close_confirmation = "NeverPrompt"

-- Key bindings
conf.keys = {
    -- Chiudi pane
    {
        key = "x",
        mods = "SUPER|SHIFT",
        action = wez.action.CloseCurrentPane { confirm = false },
    },
    -- Split verticale (divide a destra)
    {
        key = "RightArrow",
        mods = "CTRL|ALT",
        action = wez.action.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    -- Split orizzontale (divide in basso)
    {
        key = "DownArrow",
        mods = "CTRL|ALT",
        action = wez.action.SplitVertical { domain = "CurrentPaneDomain" },
    },
    -- Navigazione tra pane
    {
        key = "LeftArrow",
        mods = "ALT",
        action = wez.action.ActivatePaneDirection "Left",
    },
    {
        key = "RightArrow",
        mods = "ALT",
        action = wez.action.ActivatePaneDirection "Right",
    },
    {
        key = "UpArrow",
        mods = "ALT",
        action = wez.action.ActivatePaneDirection "Up",
    },
    {
        key = "DownArrow",
        mods = "ALT",
        action = wez.action.ActivatePaneDirection "Down",
    },
}

return conf
