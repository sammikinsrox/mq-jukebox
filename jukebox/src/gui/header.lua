local function header()
    -- Toggle Macro Section
    if UserSettings.ToggleMacro then
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    end
    UserSettings.ToggleMacro = ImGui.Checkbox('Toggle Macro', UserSettings.ToggleMacro)
    ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    ImGui.SetItemTooltip('Toggles the macro on and off. When toggled off, the macro will not run.')

    ImGui.SameLine()

    -- Toggle Verbose Section
    if UserSettings.Debug then
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    end
    UserSettings.Debug = ImGui.Checkbox('Toggle Debug', UserSettings.Debug)
    ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    ImGui.SetItemTooltip('Enable this to toggle debugging in the MQ2 Chat Window.')
    

    if ImGui.Button('Save Settings') then
        Vars.SaveSettings(UserSettings)
        ConsoleHistory:addMessage('Settings Saved')
    end
end

return header