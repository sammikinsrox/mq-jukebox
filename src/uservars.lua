--- @type Mq
local mq = require('mq')
---------------------------------------------------
-- User Variables
---------------------------------------------------
UserSettings = {
    ToggleMacro = false,
    ToggleVerbose = true,
    ManageCoPilot = {
        Bellow = false,
        VaingloriousShout = false,
        Selos = false,
        Cooldowns = false,
        BurnTrash = false,
        BurnBoss = false,
        CoolDownDelay = 5.5,
        Ability = {
            FierceEye = {
                Trash = false,
                Boss = false,
            },
            QuickTime = {
                Trash = false,
                Boss = false,
            },
            Cacophony = {
                Trash = false,
                Boss = false,
            },
            LyricalPrankster = {
                Trash = false,
                Boss = false,
            },
            SongofStone = {
                Trash = false,
                Boss = false,
            },
            BladedSong = {
                Trash = false,
                Boss = false,
            },
            SpireoftheMinstrels = {
                Trash = false,
                Boss = false,
            },
            FuneralDirge = {
                Trash = false,
                Boss = false,
            },
            FlurryofNotes = {
                Trash = false,
                Boss = false,
            },
            FrenziedKicks = {
                Trash = false,
                Boss = false,
            },
            Epic = {
                Trash = false,
                Boss = false,
            },
            ThousandBlades = {
                Trash = false,
                Boss = false,
            },
            DanceofBlades = {
                Trash = false,
                Boss = false,
            },
            ShieldofNotes = {
                Trash = false,
                Boss = false,
            },
            ChestSlot = {
                Trash = false,
                Boss = false,
            },
        }
    },
    ManageCombat = {
        Toggle = false,
        Assist = false,
        AssistPct = 100,
        AssistPctScatter = 20,
        AssistRange = 85,
        AssistRangeScatter = 20,
        UseCamp = false,
        CampScatter = 35,
        AutoRecover = false,

    },
    ManageGems = {
        Toggle = false,
        TwistResting = {},
        TwistCombat = {},
    },
    ManageMez = {
        Toggle = false,
        MezWhen = 3,
        MezRange = 100,
    },
    ManagePull = {
        Toggle = false,
        XYRange = 1000,
        ZRange = 0,
        Fadewhen = 5,
    },
}

--------------------------------------------------
-- Variables
--------------------------------------------------
CampLocationX = mq.TLO.Me.X()
CampLocationY = mq.TLO.Me.Y()
CampLocationZ = mq.TLO.Me.Z()                                    -- May not ever be used, but its there.
SettingsFileName = 'jukebox_' .. mq.TLO.Me.CleanName() .. '.lua' -- The settings filename is based on the character name.
ChestSlot = tostring(mq.TLO.Me.Inventory(17).ID())               -- The ID of the item in the chest slot.

--------------------------------------------------
--             JustSettingsThings.com
--- THE dating site for loading and saving settings
--------------------------------------------------
-- This function loads and saves user settings for the mnmbard_[CharacterName].lua script.
-- It checks if the settings file exists, and if not, it creates a new one.
-- The function also updates the CoolDownDelay value in the UserSettings table.
local function LoadSettings()
    local configData, err = loadfile(mq.configDir .. '/' .. SettingsFileName)
    if configData then
        UserSettings = configData()
    else
        mq.pickle(SettingsFileName, UserSettings)
    end
end

-- This function saves the updated settings to the UserSettings table.
-- It also updates the CoolDownDelay value in the UserSettings table.
-- The updated settings are then saved to a file with a specific name.
-- Finally, the CoolDownDelay value is divided by 10 to restore its original value.
local function SaveSettings(updatedSettings)
    UserSettings.ManageCoPilot.CoolDownDelay = updatedSettings.ManageCoPilot.CoolDownDelay * 10
    ConsoleHistory:addMessage('Saving Settings to ' .. SettingsFileName)
    mq.pickle(SettingsFileName, updatedSettings)
    UserSettings.ManageCoPilot.CoolDownDelay = updatedSettings.ManageCoPilot.CoolDownDelay / 10
end
LoadSettings()
UserSettings.ManageCoPilot.CoolDownDelay = UserSettings.ManageCoPilot.CoolDownDelay / 10

--------------------------------------------------
-- Path: vars.lua
--------------------------------------------------

return {
    UserSettings = UserSettings,
    SaveSettings = SaveSettings,
    ChestSlot = ChestSlot,
}
