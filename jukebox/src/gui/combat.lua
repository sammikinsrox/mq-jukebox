local function Combat()
    if ImGui.BeginTabItem('Auto-Combat') then
        ImGui.SetItemTooltip(
            'Auto-Combat will automatically engage and kill mobs for you.\nThis is intended to be used while you\'re AFK, but can be used while you\'re playing as well.')
        -- Combat Tab Start
        if UserSettings.ManageCombat.Toggle then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCombat.Toggle = ImGui.Checkbox('Manage Combat', UserSettings.ManageCombat.Toggle)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('Toggle on Combat Management.\nEnabling/Disabling this setting will turn on/off ALL combat settings below.')

        ImGui.Separator()

        --[[
        -- Assist checkbox
        if UserSettings.ManageCombat.Assist then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCombat.Assist = ImGui.Checkbox('Assist Main Assist / Main Tank', UserSettings.ManageCombat.Assist)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('Automagically assist the main assist or main tank.')
        ]]

        -- Assist Range Slider
        if UserSettings.ManageCombat.Assist then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        ImGui.Text('Assist Range')
        UserSettings.ManageCombat.AssistRange = ImGui.SliderInt('##AssistRange', UserSettings.ManageCombat.AssistRange, 1, 100)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('The range, in feet, that you will assist the main assist or main tank.\nExample: A range of 100 will assist once the target has reached 100 feet from you.')

        -- Assist Range Scatter Slider
        if UserSettings.ManageCombat.Assist then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        ImGui.Text('Assist Range Scattering')
        UserSettings.ManageCombat.AssistRangeScatter = ImGui.SliderInt('##AssistRangeScatter',
            UserSettings.ManageCombat.AssistRangeScatter, 0, 100)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('The randomness/variance from the Assist Range. Set to 0 to disable.\nWith Assist Range at 70 and Scattering at 30, you will assist at a range anywhere from 40 feet to 100 feet away from your current position.\n(Why? Because randomness looks more organic.)')

        -- Assist Percent Slider
        if UserSettings.ManageCombat.Assist then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        ImGui.Text('Assist at Percent HP')
        UserSettings.ManageCombat.AssistPct = ImGui.SliderInt('##AssistPct', UserSettings.ManageCombat.AssistPct, 1, 100)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('The targets HP percent must be equal to or less than this number BEFORE you assist the main assist.\nExample: Setting this to 85 will assist the main assist at 85 or less percent HP.')

        -- Assist Percent Scatter Slider
        if UserSettings.ManageCombat.Assist then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        ImGui.Text('Assist Percent Scattering')
        UserSettings.ManageCombat.AssistPctScatter = ImGui.SliderInt('##AssistPctScatter',
            UserSettings.ManageCombat.AssistPctScatter, 0, 100)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('The randomness/variance from the Assist at Percent HP. Set to 0 to disable.\nWith Assist Percent at 70 and Scattering at 30, you will assist anywhere from 40 percent hp to 100 percent hp\n(Why? Because randomness looks more organic.)')

        ImGui.Separator()

        -- Use Camp checkbox
        if UserSettings.ManageCombat.UseCamp then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCombat.UseCamp = ImGui.Checkbox('Use Camp', UserSettings.ManageCombat.UseCamp)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('Upon runtime, this macro sets your current location as its camp location. If this is enabled, you\'ll return to this location after combat.\nRecommend enabling "Camp Scattering" so that there is some variance to where you\'ll return to.')

        -- Camp Scatter Slider
        if UserSettings.ManageCombat.UseCamp then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        ImGui.Text('Camp Location Scattering')
        UserSettings.ManageCombat.CampScatter = ImGui.SliderInt('##CampScatter', UserSettings.ManageCombat.CampScatter, 0, 100)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('The randomness/variance for your camp location. Set to 0 to disable and return to the same exact spot each time.\nSetting this to 50 will add a variance between 0 and 50 feet to your camp location.\n(Why? Because randomness looks more organic.)')

        -- Set Camp Location Button
        if ImGui.Button('Set Camp Location') then
            CampLocationX = mq.TLO.Me.X()
            CampLocationY = mq.TLO.Me.Y()
            CampLocationZ = mq.TLO.Me.Z()
        end

        -- Display Camp Location
        ImGui.Text('Camp Location Y: ' .. math.floor(CampLocationY))
        ImGui.Text('Camp Location X: ' .. math.floor(CampLocationX))

        ImGui.Separator()

        --[[
    -- Auto Recover checkbox
    if UserSettings.ManageCombat.AutoRecover then
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    end
    UserSettings.ManageCombat.AutoRecover = ImGui.Checkbox('Auto Recover', UserSettings.ManageCombat.AutoRecover)
    ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
    ImGui.SetItemTooltip('Enable this to automatically recover after combat.\nRecovery is at 35% or less of endurance or mana.\nUses Rallying Solo AA.')
    ]]
        --

        ImGui.EndTabItem()
        -- End Combat Tab
    end
end

return Combat
