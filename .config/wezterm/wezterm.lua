local wezterm = require("wezterm")
local action = wezterm.action

wezterm.on("update-right-status", function(window, pane)
    local active_workspace = wezterm.mux.get_active_workspace()
    local formatted_workspaces = {}

    for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
        if workspace == active_workspace then
            table.insert(
                formatted_workspaces,
                wezterm.format({
                    { Attribute = { Intensity = "Bold" } },
                    { Text = workspace },
                })
            )
        else
            table.insert(formatted_workspaces, workspace)
        end
    end

    window:set_right_status(table.concat(formatted_workspaces, " | "))
end)

return {
    color_scheme = "OneDark (base16)",
    font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Medium" }),
    font_size = 9,
    inactive_pane_hsb = {
        brightness = 0.75,
    },
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- wezterm show-keys --lua
    keys = {
        -- Panes
        { mods = "ALT", key = "h", action = action.ActivatePaneDirection("Left") },
        { mods = "ALT", key = "j", action = action.ActivatePaneDirection("Down") },
        { mods = "ALT", key = "k", action = action.ActivatePaneDirection("Up") },
        { mods = "ALT", key = "l", action = action.ActivatePaneDirection("Right") },
        { mods = "ALT", key = "f", action = action.TogglePaneZoomState },
        {
            mods = "ALT",
            key = "Enter",
            action = wezterm.action_callback(function(window, pane)
                local pane_info = pane:get_dimensions()
                if pane_info.cols > pane_info.viewport_rows * 2.5 then
                    window:perform_action(action.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
                else
                    window:perform_action(action.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
                end
            end),
        },
        { mods = "ALT|SHIFT", key = "q", action = action.CloseCurrentPane({ confirm = true }) },

        -- Tabs
        { mods = "ALT", key = "1", action = action.ActivateTab(0) },
        { mods = "ALT", key = "2", action = action.ActivateTab(1) },
        { mods = "ALT", key = "3", action = action.ActivateTab(2) },
        { mods = "ALT", key = "4", action = action.ActivateTab(3) },
        { mods = "ALT", key = "5", action = action.ActivateTab(4) },
        { mods = "ALT", key = "6", action = action.ActivateTab(5) },
        { mods = "ALT", key = "7", action = action.ActivateTab(6) },
        { mods = "ALT", key = "8", action = action.ActivateTab(7) },
        { mods = "ALT", key = "9", action = action.ActivateTab(8) },
        { mods = "ALT", key = "0", action = action.ActivateTab(-1) },

        -- Scroll
        { mods = "ALT", key = "u", action = action.ScrollByPage(-0.5) },
        { mods = "ALT", key = "d", action = action.ScrollByPage(0.5) },

        -- Search
        { mods = "ALT", key = "/", action = action.Search("CurrentSelectionOrEmptyString") },

        -- Copy
        { mods = "ALT", key = "c", action = action.ActivateCopyMode },

        -- Workspaces
        { mods = "ALT", key = "w", action = action.ShowLauncherArgs({ flags = "WORKSPACES|FUZZY" }) },
        { mods = "ALT", key = "Tab", action = action.SwitchWorkspaceRelative(1) },
        { mods = "ALT|SHIFT", key = "Tab", action = action.SwitchWorkspaceRelative(-1) },
        {
            mods = "ALT",
            key = "p",
            action = wezterm.action_callback(function(window, pane)
                local choices = {}
                for _, project in ipairs(wezterm.read_dir(wezterm.home_dir .. "/Documents")) do
                    table.insert(choices, { label = project })
                end
                window:perform_action(
                    action.InputSelector({
                        title = "Projects",
                        choices = choices,
                        fuzzy = true,
                        action = wezterm.action_callback(function(window, pane, id, label)
                            if label then
                                window:perform_action(
                                    action.SwitchToWorkspace({
                                        name = label,
                                        spawn = {
                                            cwd = label,
                                        },
                                    }),
                                    pane
                                )
                            end
                        end),
                    }),
                    pane
                )
            end),
        },

        -- Miscellaneous
        { mods = "ALT|SHIFT", key = "p", action = action.ActivateCommandPalette },
    },
}
