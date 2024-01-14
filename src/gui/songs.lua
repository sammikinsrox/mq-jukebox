--- @type Mq
local mq = require('mq')

local function Songs()
    -- Songs Tab Start
    if ImGui.BeginTabItem('Songs') then
        -- Camp Scatter Slider
        if UserSettings.ManageGems.Toggle then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        end
        UserSettings.ManageGems.Toggle = ImGui.Checkbox('Manage Songs', UserSettings.ManageGems.Toggle)
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFFFF)
        ImGui.SetItemTooltip('Enable this to toggle management of songs.\nThis will automatically cast songs when they are available.')
        ImGui.Separator()
        -- A ImGui table for choosing songs
        local gems = {
            { name = mq.TLO.Me.Gem(1).Name() or "No Gem",  combatSetting = 'Gems.Gem1.Combat',  restingSetting = 'Gems.Gem1.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(1).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(2).Name() or "No Gem",  combatSetting = 'Gems.Gem2.Combat',  restingSetting = 'Gems.Gem2.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(2).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(3).Name() or "No Gem",  combatSetting = 'Gems.Gem3.Combat',  restingSetting = 'Gems.Gem3.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(3).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(4).Name() or "No Gem",  combatSetting = 'Gems.Gem4.Combat',  restingSetting = 'Gems.Gem4.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(4).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(5).Name() or "No Gem",  combatSetting = 'Gems.Gem5.Combat',  restingSetting = 'Gems.Gem5.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(5).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(6).Name() or "No Gem",  combatSetting = 'Gems.Gem6.Combat',  restingSetting = 'Gems.Gem6.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(6).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(7).Name() or "No Gem",  combatSetting = 'Gems.Gem7.Combat',  restingSetting = 'Gems.Gem7.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(7).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(8).Name() or "No Gem",  combatSetting = 'Gems.Gem8.Combat',  restingSetting = 'Gems.Gem8.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(8).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(9).Name() or "No Gem",  combatSetting = 'Gems.Gem9.Combat',  restingSetting = 'Gems.Gem9.Resting',  tooltip = 'Use ' .. (mq.TLO.Me.Gem(9).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(10).Name() or "No Gem", combatSetting = 'Gems.Gem10.Combat', restingSetting = 'Gems.Gem10.Resting', tooltip = 'Use ' .. (mq.TLO.Me.Gem(10).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(11).Name() or "No Gem", combatSetting = 'Gems.Gem11.Combat', restingSetting = 'Gems.Gem11.Resting', tooltip = 'Use ' .. (mq.TLO.Me.Gem(11).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(12).Name() or "No Gem", combatSetting = 'Gems.Gem12.Combat', restingSetting = 'Gems.Gem12.Resting', tooltip = 'Use ' .. (mq.TLO.Me.Gem(12).Name() or "No Gem") },
            { name = mq.TLO.Me.Gem(13).Name() or "No Gem", combatSetting = 'Gems.Gem13.Combat', restingSetting = 'Gems.Gem13.Resting', tooltip = 'Use ' .. (mq.TLO.Me.Gem(13).Name() or "No Gem") },
        }

        -- Add a gem to the queue
        local function addGem(songIndex, gemIndex, isCombat)
            if isCombat then
                UserSettings.ManageGems.TwistCombat[songIndex] = gemIndex
            else
                UserSettings.ManageGems.TwistResting[songIndex] = gemIndex
            end
        end

        -- Remove a gem from the queue
        local function removeGem(songIndex, isCombat)
            if isCombat then
                UserSettings.ManageGems.TwistCombat[songIndex] = nil
            else
                UserSettings.ManageGems.TwistResting[songIndex] = nil
            end
        end

        if ImGui.TreeNode("Resting Settings") then
            for i = 1, 13 do
                ImGui.PushID(i)
                if ImGui.Button("C") then
                    removeGem(i, false)
                end
                ImGui.SameLine()
                local currentRestingGem = UserSettings.ManageGems.TwistResting[i] or ""
                local selectedGemName = ""
                if currentRestingGem ~= "" then
                    selectedGemName = gems[currentRestingGem] and gems[currentRestingGem].name or ""
                end
                local newSelection = currentRestingGem
                if ImGui.BeginCombo("Song " .. i, "Gem " .. currentRestingGem .. " - " .. selectedGemName) then
                    for j, gem in ipairs(gems) do
                        local gemName = "Gem " .. tostring(j) .. " - " .. gem.name
                        local is_selected = (newSelection == tostring(j))
                        if ImGui.Selectable(gemName, is_selected) then
                            newSelection = tostring(j)
                        end
                    end
                    ImGui.EndCombo()
                end
                if tonumber(newSelection) ~= currentRestingGem then
                    if newSelection == "" then
                        removeGem(i, false)
                    else
                        addGem(i, tonumber(newSelection), false)
                    end
                end
                ImGui.PopID()
            end
            ImGui.TreePop()
        end

        if ImGui.TreeNode("Combat Settings") then
            for i = 1, 13 do
                ImGui.PushID(i + 100) -- add 100 to avoid ID conflicts with the resting settings
                if ImGui.Button("C") then
                    removeGem(i, true)
                end
                ImGui.SameLine()
                local currentCombatGem = UserSettings.ManageGems.TwistCombat[i] or ""
                local selectedGemName = ""
                if currentCombatGem ~= "" then
                    selectedGemName = gems[currentCombatGem] and gems[currentCombatGem].name or ""
                end
                local newSelection = currentCombatGem
                if ImGui.BeginCombo("Song " .. i, "Gem " .. currentCombatGem .. " - " .. selectedGemName) then
                    for j, gem in ipairs(gems) do
                        local gemName = "Gem " .. tostring(j) .. " - " .. gem.name
                        local is_selected = (newSelection == tostring(j))
                        if ImGui.Selectable(gemName, is_selected) then
                            newSelection = tostring(j)
                        end
                    end
                    ImGui.EndCombo()
                end
                if tonumber(newSelection) ~= currentCombatGem then
                    if newSelection == "" then
                        removeGem(i, true)
                    else
                        addGem(i, tonumber(newSelection), true)
                    end
                end
                ImGui.PopID()
            end
            ImGui.TreePop()
        end

        ImGui.EndTabItem()
    end
end

return Songs