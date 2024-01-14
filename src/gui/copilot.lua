local function Copilot()
    -- Copilot Tab Start
    if ImGui.BeginTabItem('Copilot') then
        ImGui.SetItemTooltip(
            'Copilot will help you manage various aspects of your bard for you, so you don\'t have to worry about it.\nThis is intended to be used while you\'re playing, but can be used while in autocombat as well.')

        -- Bellow checkbox
        if UserSettings.ManageCoPilot.Bellow then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCoPilot.Bellow = ImGui.Checkbox('Manage Boastful Bellow',
            UserSettings.ManageCoPilot.Bellow)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip(
            'Enable this to toggle management of Boastful Bellow.\nThis will automatically cast Boastful Bellow on the target if you are in combat and recast once Boastful Conclusion has been consumed.')

        -- Vainglorious Shout checkbox
        if UserSettings.ManageCoPilot.VaingloriousShout then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCoPilot.VaingloriousShout = ImGui.Checkbox('Manage Vainglorious Shout',
            UserSettings.ManageCoPilot.VaingloriousShout)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip(
            'Enable this to toggle management of Vainglorious Shout.\nSimilar to how Boastful Bellow works, this will recast Vainglorious Shout once Boastful Conclusion has been consumed.')

        ImGui.Separator()

        -- Selos checkbox
        if UserSettings.ManageCoPilot.Selos then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCoPilot.Selos = ImGui.Checkbox('Manage Selos', UserSettings.ManageCoPilot.Selos)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip(
            'Enable this to keep selos on the group.\nRequires Selos Sonata AA.\nWill not cast if invis or sitting.')

        ImGui.Separator()

        -- Manage Cooldowns checkbox
        if UserSettings.ManageCoPilot.Cooldowns then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCoPilot.Cooldowns = ImGui.Checkbox('Manage Cooldowns',
            UserSettings.ManageCoPilot.Cooldowns)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip(
            'Enable this to toggle management of cooldowns.\nThis will automatically cast cooldowns when they are available, including your epic.')
        ImGui.Text('Cooldown Delay')

        -- Cooldown Delay Slider
        UserSettings.ManageCoPilot.CoolDownDelay = ImGui.SliderFloat('##CooldownDelay',
            UserSettings.ManageCoPilot.CoolDownDelay, 0.5, 120, '%0.1f')
        ImGui.SameLine()
        ImGui.PushItemWidth(50)
        if ImGui.Button('+') then
            if UserSettings.ManageCoPilot.CoolDownDelay < 120 then
                UserSettings.ManageCoPilot.CoolDownDelay = math.min(
                    UserSettings.ManageCoPilot.CoolDownDelay + 0.1, 120)
            end
        end
        ImGui.SameLine()
        if ImGui.Button('-') then
            if UserSettings.ManageCoPilot.CoolDownDelay > 0.5 then
                UserSettings.ManageCoPilot.CoolDownDelay = math.max(
                    UserSettings.ManageCoPilot.CoolDownDelay - 0.1, 0.5)
            end
        end
        ImGui.PopItemWidth()
        ImGui.SetItemTooltip(
            'Set the delay between casting cooldowns.\nThis is to prevent the macro from casting all of your cooldowns at once.')

        ImGui.Separator()

        -- Burn Boss checkbox
        if UserSettings.ManageCoPilot.BurnBoss then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageCoPilot.BurnBoss = ImGui.Checkbox('Burn Named', UserSettings.ManageCoPilot.BurnBoss)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip(
            'Enable this to toggle burning NAMED creatures.\nThis will use all abilities with no cooldown delay.')

        ImGui.Separator()

        -- Ability Selection
        -- This is a list of all abilities that can be managed by the CoPilot.
        if ImGui.TreeNode('Cooldown Selection - Cast Abilities on:') then
            local abilities = {
                { name = 'Bladed Song Named',            setting = 'Ability.BladedSong.Boss',           tooltip = 'Use Bladed Song on Named Mobs.' },
                { name = 'Bladed Song Trash',            setting = 'Ability.BladedSong.Trash',          tooltip = 'Use Bladed Song on Trash Mobs.' },
                { name = 'Cacophony Named',              setting = 'Ability.Cacophony.Boss',            tooltip = 'Use Cacophony on Named Mobs.' },
                { name = 'Cacophony Trash',              setting = 'Ability.Cacophony.Trash',           tooltip = 'Use Cacophony on Trash Mobs.' },
                { name = 'Chest Slot Named',             setting = 'Ability.ChestSlot.Named',           tooltip = 'Use Chest Slot on Named Mobs.' },
                { name = 'Chest Slot Trash',             setting = 'Ability.ChestSlot.Trash',           tooltip = 'Use Chest Slot on Trash Mobs.' },
                { name = 'Dance of Blades Named',        setting = 'Ability.DanceofBlades.Boss',        tooltip = 'Use Dance of Blades on Named Mobs' },
                { name = 'Dance of Blades Trash',        setting = 'Ability.DanceofBlades.Trash',       tooltip = 'Use Dance of Blades on Trash Mobs.' },
                { name = 'Epic 2.0 Named',               setting = 'Ability.Epic.Boss',                 tooltip = 'Use Spirit of Vesagran on Named Mobs.' },
                { name = 'Epic 2.0 Trash',               setting = 'Ability.Epic.Trash',                tooltip = 'Use Spirit of Vesagran on Trash Mobs.' },
                { name = 'Flurry of Notes Named',        setting = 'Ability.FlurryofNotes.Boss',        tooltip = 'Use Flurry of Notes on Named Mobs.' },
                { name = 'Flurry of Notes Trash',        setting = 'Ability.FlurryofNotes.Trash',       tooltip = 'Use Flurry of Notes on Trash Mobs.' },
                { name = 'Frenzied Kicks Named',         setting = 'Ability.FrenziedKicks.Boss',        tooltip = 'Use Frenzied Kicks on Named Mobs.' },
                { name = 'Frenzied Kicks Trash',         setting = 'Ability.FrenziedKicks.Trash',       tooltip = 'Use Frenzied Kicks on Trash Mobs.' },
                { name = 'Funeral Dirge Named',          setting = 'Ability.FuneralDirge.Boss',         tooltip = 'Use Funeral Dirge on Named Mobs.' },
                { name = 'Funeral Dirge Trash',          setting = 'Ability.FuneralDirge.Trash',        tooltip = 'Use Funeral Dirge on Trash Mobs.' },
                { name = 'Fierce Eye Named',             setting = 'Ability.FierceEye.Boss',            tooltip = 'Use Fierce Eye on Named Mobs.' },
                { name = 'Fierce Eye Trash',             setting = 'Ability.FierceEye.Trash',           tooltip = 'Use Fierce Eye on Trash Mobs.' },
                { name = 'Quick Time Named',             setting = 'Ability.QuickTime.Boss',            tooltip = 'Use Quick Time on Named Mobs.' },
                { name = 'Quick Time Trash',             setting = 'Ability.QuickTime.Trash',           tooltip = 'Use Quick Time on Trash Mobs.' },
                { name = 'Lyrical Prankster Named',      setting = 'Ability.LyricalPrankster.Boss',     tooltip = 'Use Lyrical Prankster on Named Mobs.' },
                { name = 'Lyrical Prankster Trash',      setting = 'Ability.LyricalPrankster.Trash',    tooltip = 'Use Lyrical Prankster on Trash Mobs.' },
                { name = 'Shield of Notes Named',        setting = 'Ability.ShieldofNotes.Boss',        tooltip = 'Use Shield of Notes on Named Mobs.' },
                { name = 'Shield of Notes Trash',        setting = 'Ability.ShieldofNotes.Trash',       tooltip = 'Use Shield of Notes on Trash Mobs.' },
                { name = 'Song of Stone Named',          setting = 'Ability.SongofStone.Boss',          tooltip = 'Use Song of Stone on Named Mobs.' },
                { name = 'Song of Stone Trash',          setting = 'Ability.SongofStone.Trash',         tooltip = 'Use Song of Stone on Trash Mobs.' },
                { name = 'Spire of the Minstrels Named', setting = 'Ability.SpireoftheMinstrels.Boss',  tooltip = 'Use Spire of the Minstrels on Named Mobs.' },
                { name = 'Spire of the Minstrels Trash', setting = 'Ability.SpireoftheMinstrels.Trash', tooltip = 'Use Spire of the Minstrels on Trash Mobs.' },
                { name = 'Thousand Blades Named',        setting = 'Ability.ThousandBlades.Boss',       tooltip = 'Use Thousand Blades on Named Mobs.' },
                { name = 'Thousand Blades Trash',        setting = 'Ability.ThousandBlades.Trash',      tooltip = 'Use Thousand Blades on Trash Mobs.' },
            }

            -- This code iterates over a list of abilities and creates buttons for each ability.
            -- The color of the button is determined based on the value of the ability's setting in the UserSettings.ManageCoPilot table.
            -- When a button is clicked, the value of the ability's setting is toggled.
            -- The tooltip for each button is set to the ability's tooltip.
            -- The buttons are arranged in rows, with the number of buttons per row determined by the value of buttonCount.
            local buttonCount = 0
            for _, ability in ipairs(abilities) do
                if Helpers.getNestedTable(UserSettings.ManageCoPilot, ability.setting) then
                    ImGui.PushStyleColor(ImGuiCol.Button, 0xFF008000)
                else
                    ImGui.PushStyleColor(ImGuiCol.Button, 0x50F0A0FF)
                end
                if ImGui.Button(ability.name, ImVec2(150, 0)) then
                    Helpers.setNestedTable(UserSettings.ManageCoPilot, ability.setting,
                        not Helpers.getNestedTable(UserSettings.ManageCoPilot, ability.setting))
                end
                ImGui.PopStyleColor()
                ImGui.SetItemTooltip(ability.tooltip)

                buttonCount = buttonCount + 1
                if buttonCount % 2 == 0 then -- change this number to fit the number of buttons per row
                    --nothing
                else
                    ImGui.SameLine()
                end
            end
            ImGui.TreePop()
            -- End Ability Selection
        end
        ImGui.EndTabItem()
        -- End Copilot Tab
    end
end

return Copilot