local function History()
    -- Console History Tab Start
    if ImGui.BeginTabItem('History') then
        ImGui.SetItemTooltip('This tab displays the history of what this script is doing.')

        ConsoleHistory:display() -- Display the console history

        ImGui.EndTabItem()
    end
end

return History
