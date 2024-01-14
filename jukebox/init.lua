--- @type Mq
mq = require('mq')
--- @type ImGui
require('ImGui')

---------------------------------------------------
-- Set EQ Client states
---------------------------------------------------
mq.cmd('/assist off')

--------------------------------------------------
-- Modules
--------------------------------------------------
-- User Vars Module
Vars                = require('src.uservars')
UserSettings        = Vars.UserSettings

-- Class Modules
ConsoleHistory      = require('src.class.console').new()
Timer               = require('src.class.timer')

-- Helper Module
Helpers = require('src.helpers')

-- Handler Modules
Handlers = require('src.Handlers')

-- Gui Modules
local GuiHeader     = require('src.gui.header')
local GuiCopilot    = require('src.gui.copilot')
local GuiCombat     = require('src.gui.combat')
local GuiSongs      = require('src.gui.songs')
local GuiHistory    = require('src.gui.console')

-----------------------------------------------------------------------------------------------------------
--                                        BEGIN INTERFACE CODE                                           --
-----------------------------------------------------------------------------------------------------------
-- Script control variables
local terminate = false

-- UI Control variables
local isOpen, shouldDraw = true, true

local function updateImGui()
    -- Don't draw the UI if the UI was closed by pressing the X button
    if not isOpen then return end

    -- isOpen will be set false if the X button is pressed on the window
    -- shouldDraw will generally always be true unless the window is collapsed
    isOpen, shouldDraw = ImGui.Begin('Jukebox', isOpen)
    -- Only draw the window contents if shouldDraw is true
    if shouldDraw then
        GuiHeader()
        if ImGui.BeginTabBar("##tabs", ImGuiTabBarFlags.None) then
            GuiCopilot()
            GuiCombat()
            GuiSongs()
            GuiHistory()
            ImGui.EndTabBar()
        end
    end
    if isOpen or not isOpen or shouldDraw or not shouldDraw then
        if UserSettings.ToggleMacro then
            -- Handle the CoPilot Setings
            if UserSettings.ManageCoPilot.Bellow then Handlers.HandleBellow() end
            if UserSettings.ManageCoPilot.VaingloriousShout then Handlers.HandleVaingloriousShout() end
            if UserSettings.ManageCoPilot.Selos then Handlers.HandleSelos() end
            if UserSettings.ManageCoPilot.Cooldowns and Helpers.CheckCombat() then
                Handlers.HandleCooldowns()
                Handlers.HandleNextAbility()
            end

            -- Handle the Combat Settings
            if UserSettings.ManageCombat.Toggle then Handlers.HandleCombat() end

            -- Handle the Songs Settings
            if UserSettings.ManageGems.Toggle then Handlers.HandleGems() end

            -- Handle the Mez Settings
            if UserSettings.ManageMez.Toggle then Handlers.HandleMez() end

            -- Handle recovery if mana or endurance are low.
            if UserSettings.ManageCombat.AutoRecover and UserSettings.ManageCombat.Toggle then Handlers.HandleRecover() end

        end
    end
    ImGui.End()
end

--------------------------------------------------
-- Bindings
--------------------------------------------------
-- Bind an MQ command /mnmbard to open the window
mq.bind('/jukebox', function() isOpen = not isOpen end)
mq.bind('/jb', function() isOpen = not isOpen end)

-- Bind an MQ command /songsstart to start the songs
mq.bind('/songsstart', function()
    if not UserSettings.ManageGems.Toggle then
        UserSettings.ManageGems.Toggle = true
        ConsoleHistory:addMessage('Starting Songs')
    end
end)

-- Bind an MQ command /songsstop to stop the songs
mq.bind('/songsstop', function()
    if UserSettings.ManageGems.Toggle then
        UserSettings.ManageGems.Toggle = false
        ConsoleHistory:addMessage('Stopping Songs')
    end
end)

-- This code initializes the ImGui window and calls the "updateImGui" function.
mq.imgui.init('jukebox', updateImGui)

-- This code creates a timer that will call the "updateImGui" function every 100 milliseconds.
while not terminate do
    mq.delay(1000)
end
