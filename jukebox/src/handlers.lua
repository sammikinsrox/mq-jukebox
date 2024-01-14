local AbilityScheduler  = require('src.class.abilityscheduler')
local GemsScheduler     = require('src.class.gemscheduler')
local Timer             = require('src.class.timer')

local CooldownScheduler = AbilityScheduler.new(UserSettings.ManageCoPilot.CoolDownDelay)
local BurnBossScheduler = AbilityScheduler.new(0.5)
local CopilotScheduler  = AbilityScheduler.new(1)

local songScheduler = GemsScheduler.new()

local AbilityCheckDelay = Timer.new(1, false, 'Ability Check Delay')
local CopilotCheckDelay = Timer.new(1, false, 'CoPilot Check Delay')
local ClickyCheckDelay  = Timer.new(1, false, 'Clicky Check Delay')
local NavTimer          = Timer.new(1, false, 'Nav Timer')
local messageCoolDown   = Timer.new(2, false, 'Message Cooldown')

local recovering        = false

AbilityCheckDelay:start()
CopilotCheckDelay:start()

-- Initialize the current ability index

---------------------------------------------------
-- Ability Handlers
---------------------------------------------------

-- Function to handle the "Boastful Bellow" ability
local function HandleBellow()
    -- Check if there is a target
    if mq.TLO.Target.ID() > 0 then
        -- Check if the player has enough endurance, the ability is ready, the target's HP is above 25%,
        -- the target does not have the "Boastful Bellow" debuff, the player is in combat, and the ability check delay has expired
        if mq.TLO.Me.PctEndurance() > 5 and mq.TLO.Me.AltAbilityReady('Boastful Bellow')() and mq.TLO.Target.PctHPs() > 25 and not mq.TLO.Target.FindBuff('name "Boastful Bellow" and caster ' .. mq.TLO.Me.CleanName())() and Helpers.CheckCombat() and CopilotCheckDelay:hasExpired() then
            -- Add "Boastful Bellow" ability to the scheduler queue
            mq.cmd('/aa act Boastful Bellow')
            ConsoleHistory:addMessage('Casting Boastful Bellow')
            CopilotCheckDelay:start()
        end
    end
end

-- Function to handle the "Vainglorious Shout" ability
local function HandleVaingloriousShout()
    -- Check if there is a target
    if mq.TLO.Target.ID() > 0 then
        -- Check if the player has enough endurance, the ability is ready, the target's HP is above 25%,
        -- the player does not have the "Vainglorious Shout" buff, the player is in combat, and the ability check delay has expired
        if mq.TLO.Me.PctEndurance() > 5 and mq.TLO.Me.AltAbilityReady('Vainglorious Shout')() and mq.TLO.Target.PctHPs() > 25 and not mq.TLO.Target.FindBuff('name "Vainglorious Shout" and caster ' .. mq.TLO.Me.CleanName())() and Helpers.CheckCombat() and CopilotCheckDelay:hasExpired() then
            -- Add "Vainglorious Shout" ability to the scheduler queue
            mq.cmd('/aa act Vainglorious Shout')
            ConsoleHistory:addMessage('Casting Vainglorious Shout')
            CopilotCheckDelay:start()
        end
    end
end

-- Function to handle the "Selo's Sonata" ability
local function HandleSelos()
    -- Check if the ability is ready, the player does not have the "Selo's" buff,
    -- the player is not sitting, the player is not invisible, and the ability check delay has expired
    if mq.TLO.Me.AltAbilityReady('Selo\'s Sonata')() and not mq.TLO.Me.FindBuff('name Selo\'s')() and not mq.TLO.Me.Sitting() and not mq.TLO.Me.Invis() and CopilotCheckDelay:hasExpired() then
        -- Add "Selo's Sonata" ability to the scheduler queue
        mq.cmd('/aa act Selo\'s Sonata')
        ConsoleHistory:addMessage('Casting Selo\'s Sonata')
        CopilotCheckDelay:start()
    end
end

-- Function: handleCooldowns
-- Description: Handles the cooldowns of abilities based on certain conditions.
--              If in combat and the ability check delay has expired, it checks if the CoPilot should burn the boss.
--              If the target is named, it checks if the ability is ready and adds it to the cooldown scheduler queue.
--              If the target is not named and the trash setting is enabled, it adds the ability to the cooldown scheduler queue.
-- Parameters: None
-- Returns: None
local function HandleCooldowns()

    -- Burn Boss
    if UserSettings.ManageCoPilot.BurnBoss and mq.TLO.Target.Named() and Helpers.CheckCombat() then
        local abilities = {
            'Fierce Eye',
            'Quick Time',
            'Cacophony',
            'Lyrical Prankster',
            'Song of Stone',
            'Bladed Song',
            'Spire of the Minstrels',
            'Funeral Dirge',
            'Flurry of Notes',
            'Frenzied Kicks',
            'Dance of Blades',
            'Shield of Notes'
        }

        for i, ability in ipairs(abilities) do
            BurnBossScheduler:addAbilityToQueue(ability)
        end
    end

    -- AA Abilities
    if Helpers.CheckCombat() and AbilityCheckDelay:hasExpired() and not mq.TLO.Target.Named() then

        -- Handles various abilities for the Bard class.
        -- Each ability is passed as a parameter along with the corresponding trash and boss settings.
        local abilities = {
            {name = 'Fierce Eye',               trash = UserSettings.ManageCoPilot.Ability.FierceEye.Trash},
            {name = 'Quick Time',               trash = UserSettings.ManageCoPilot.Ability.QuickTime.Trash},
            {name = 'Cacophony',                trash = UserSettings.ManageCoPilot.Ability.Cacophony.Trash},
            {name = 'Lyrical Prankster',        trash = UserSettings.ManageCoPilot.Ability.LyricalPrankster.Trash},
            {name = 'Song of Stone',            trash = UserSettings.ManageCoPilot.Ability.SongofStone.Trash},
            {name = 'Bladed Song',              trash = UserSettings.ManageCoPilot.Ability.BladedSong.Trash},
            {name = 'Spire of the Minstrels',   trash = UserSettings.ManageCoPilot.Ability.SpireoftheMinstrels.Trash},
            {name = 'Funeral Dirge',            trash = UserSettings.ManageCoPilot.Ability.FuneralDirge.Trash},
            {name = 'Flurry of Notes',          trash = UserSettings.ManageCoPilot.Ability.FlurryofNotes.Trash},
            {name = 'Frenzied Kicks',           trash = UserSettings.ManageCoPilot.Ability.FrenziedKicks.Trash},
            {name = 'Dance of Blades',          trash = UserSettings.ManageCoPilot.Ability.DanceofBlades.Trash},
            {name = 'Shield of Notes',          trash = UserSettings.ManageCoPilot.Ability.ShieldofNotes.Trash}
        }

        local function HandleAbility(abilityName)
            if mq.TLO.Me.AltAbilityReady(abilityName)()  then
                if not CooldownScheduler:isAbilityInQueue() then
                    CooldownScheduler:addAbilityToQueue(abilityName)
                    return
                end
            end
        end

        for i, ability in ipairs(abilities) do
            HandleAbility(ability.name, ability.trash)
        end

        AbilityCheckDelay:start()
        CooldownScheduler:castNextAbility()
    end

    -- Clickies
    if Helpers.CheckCombat() and ClickyCheckDelay:hasExpired() then
        -- Checks if the item 'Blade of Vesagran' is ready to use, the buff 'Spirit of Vesagran' is not active, and the ability check delay has expired.
        if mq.TLO.Me.ItemReady('Blade of Vesagran')() and mq.TLO.Me.FindBuff('name Spirit of Vesagran').ID() == nil and ClickyCheckDelay:hasExpired() then
            if not mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.Epic.Trash then
                mq.cmd('/stopcast')
                mq.cmd('/useitem Blade of Vesagran')
                ConsoleHistory:addMessage('Casting Blade of Vesagran')
            else
                if mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.Epic.Boss then
                    mq.cmd('/stopcast')
                    mq.cmd('/useitem Blade of Vesagran')
                    ConsoleHistory:addMessage('Casting Blade of Vesagran')
                end
            end
        end

        -- Checks if the Chest Slot ability is ready to cast and casts it based on the target type (trash or boss).
        if mq.TLO.Me.ItemReady(Vars.ChestSlot)() and ClickyCheckDelay:hasExpired() then -- Check if the Chest Slot is ready to cast.
            if not mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.ChestSlot.Trash then
                mq.cmd('/useitem 17')
                ConsoleHistory:addMessage('Casting Chest Slot')
            else
                if mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.ChestSlot.Boss then
                    mq.cmd('/useitem 17')
                    ConsoleHistory:addMessage('Casting Chest Slot')
                end
            end
        end

        -- This code checks if the ability "Thousand Blades" is ready and casts it based on the target type and user settings.
        if mq.TLO.Me.CombatAbilityReady('Thousand Blades')() and ClickyCheckDelay:hasExpired() then
            if not mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.ThousandBlades.Trash then
                mq.cmd('/doability "Thousand Blades"')
                ConsoleHistory:addMessage('Casting Thousand Blades')
            end
        else
            if mq.TLO.Target.Named() and UserSettings.ManageCoPilot.Ability.ThousandBlades.Boss then
                mq.cmd('/doability "Thousand Blades"')
                ConsoleHistory:addMessage('Casting Thousand Blades')
            end
        end

        ClickyCheckDelay:start()
    end
end

-- handleCombat is a function that manages combat based on user settings.
-- It checks if combat management is toggled on and if the player is not already in combat.
-- If conditions are met, it selects a target to assist, starts combat, and performs a full reset if necessary.
local function HandleCombat()
    -- Check if combat management is toggled on and the player is not already in combat
    if UserSettings.ManageCombat.Toggle and not Helpers.CheckCombat() and not recovering then
        -- Calculate assist range and assist percentage with random scattering
        local AssistRange = UserSettings.ManageCombat.AssistRange + math.random(0, UserSettings.ManageCombat.AssistRangeScatter)
        local AssistPct = UserSettings.ManageCombat.AssistPct + math.random(0, UserSettings.ManageCombat.AssistPctScatter)

        -- Check if there are valid targets within the assist range
        function CheckForTargets()
            if mq.TLO.SpawnCount('npc xtarhater radius ' .. AssistRange) and HasReset then return true end
            return false
        end

        -- Select a target to assist based on group roles
        function GetTarget()
            if CheckForTargets() then
                if mq.TLO.Group.MainAssist.ID() ~= nil then
                    mq.TLO.Group.MainAssist.DoAssist()
                end
                if mq.TLO.Group.MainAssist.ID() == nil and mq.TLO.Group.MainTank.ID() ~= nil then
                    mq.TLO.Group.MainTank.DoAssist()
                end
                if mq.TLO.Group.MainAssist.ID() == nil and mq.TLO.Group.MainTank.ID() == nil then
                    mq.cmd('/xtarget target 1')
                end
                if mq.TLO.Target.ID() > 0 then
                    ConsoleHistory:addMessage('Target Acquired: ' .. mq.TLO.Target.Name())
                end
            end
        end

        -- Start combat by facing the target, positioning, and initiating attacks
        -- Function to start combat
        function StartCombat()
            mq.cmd('/echo starting combat')                                          -- Print a message indicating that combat is starting
            if Helpers.CheckXTargetList() and mq.TLO.Target.Distance() <= AssistRange and mq.TLO.Target.PctHPs() <= AssistPct then
                mq.cmd('/face ' .. mq.TLO.Target())                                  -- Face the target
                mq.cmd('/stick behind loose')                                        -- Stick behind the target
                mq.cmd('/attack on')                                                 -- Enable auto-attack
                mq.cmd('/pet attack')                                                -- Command the pet to attack
                HasReset = false                                                     -- Reset flags
                ReturnedToCamp = false                                               -- Reset flags
                if Helpers.CheckCombat() and messageCoolDown:hasExpired() then
                    ConsoleHistory:addMessage('Attacking: ' .. mq.TLO.Target.Name()) -- Display a message indicating the target being attacked
                    messageCoolDown:start()                                          -- Set a cooldown for the message
                end
            end
        end

        -- Perform a full reset if there are no valid targets within the assist range
        function FullReset()
            if CheckForTargets() then
                HasReset = true
                return
            else
                -- Check if UserSettings.ManageCombat.UseCamp is true, HasReset is false, and messageCoolDown has expired
                if UserSettings.ManageCombat.UseCamp and not HasReset then
                    -- Generate random coordinates within the CampScatter range
                    local ReturnToX = CampLocationX + math.random(0, UserSettings.ManageCombat.CampScatter)
                    local ReturnToY = CampLocationY + math.random(0, UserSettings.ManageCombat.CampScatter)

                    -- Check if current position is not equal to the generated coordinates and NavTimer has expired
                    if mq.TLO.Me.X() ~= ReturnToX and mq.TLO.Me.Y() ~= ReturnToY and NavTimer:hasExpired() then
                        -- Set navigation to the generated coordinates
                        mq.cmd('/nav locyx ' .. ReturnToY .. ' ' .. ReturnToX)

                        -- Set HasReset to true
                        HasReset = true

                        -- Reset NavTimer and messageCoolDown to 1 second
                        NavTimer:start()
                        messageCoolDown:start()
                    end
                end
                mq.cmd('/attack off')
                mq.cmd('/pet back')
            end
        end

        -- Perform a full reset if it hasn't been done yet, select a target, and start combat
        if not HasReset and not Helpers.CheckCombat() then FullReset() end
        if CheckForTargets then GetTarget() end
        if mq.TLO.Target.ID() > 0 then StartCombat() end
    end
end

local callDelayTimer = Timer.new(0.75)
callDelayTimer:start()

local function HandleGems()
    -- Check if the cooldown timer has expired
    local CastTimeLeft = mq.TLO.Me.CastTimeLeft()

    if Helpers.CheckCombat() and not mq.TLO.Me.Invis() and not mq.TLO.Me.Sitting() and (CastTimeLeft == 0 or CastTimeLeft > 1000000) and not songScheduler.isPlayingCombatSongs then
        if callDelayTimer:hasExpired() then
            songScheduler:stopRestingSongs()
            songScheduler:stopCombatSongs()
            songScheduler:playCombatSongs()
            callDelayTimer:start()
            ConsoleHistory:addMessage('Playing Combat Songs')
        end
    elseif not Helpers.CheckCombat() and not mq.TLO.Me.Invis() and not mq.TLO.Me.Sitting() and (CastTimeLeft == 0 or CastTimeLeft > 1000000) and not songScheduler.isPlayingRestingSongs then
        if callDelayTimer:hasExpired() then
            songScheduler:stopRestingSongs()
            songScheduler:stopCombatSongs()
            songScheduler:playRestingSongs()
            callDelayTimer:start()
            ConsoleHistory:addMessage('Playing Resting Songs')
        end
    elseif (songScheduler.isPlayingCombatSongs or songScheduler.isPlayingRestingSongs) and (CastTimeLeft == 0 or CastTimeLeft > 1000000) then
        if callDelayTimer:hasExpired() then
            songScheduler:castNextGem()
            callDelayTimer:start()
        end
    end
end

local function HandleMez()
    --todo
end

local function HandlePulls()
    --todo
end

-- Function: handleRecover
-- Description: Handles the mana/endurance recovery for your bard. If you are low, you'll use rallying solo when in a RESTING state.
local function HandleRecover()
    if mq.TLO.Me.PctEndurance() < 30 or mq.TLO.Me.PctMana() < 30 and UserSettings.ManageCombat.Toggle and not recovering then
        recovering = true
        mq.TLO.Me.Sit()

        if mq.TLO.Me.CombatState() == 'RESTING' and mq.TLO.Me.AltAbilityReady('Rallying Solo') then
            mq.cmd('/aa act Rallying Solo')
            mq.TLO.Me.Sit()
        end

        if mq.TLO.Me.PctEndurance() >= 90 and mq.TLO.Me.PctMana() >= 90 then
            mq.TLO.Me.Stand()
            recovering = false
        end

        if mq.TLO.Me.CombatState() == 'COMBAT' then
            mq.TLO.Me.Stand()
            recovering = false
        end
    end
end

local function HandleNextAbility()
    BurnBossScheduler:castNextAbility()
    CopilotScheduler:castNextAbility()
    CooldownScheduler:castNextAbility()
end

---------------------------------------------------
-- Path: handlers.lua
---------------------------------------------------
return {
    HandleBellow = HandleBellow,
    HandleVaingloriousShout = HandleVaingloriousShout,
    HandleSelos = HandleSelos,
    HandleCooldowns = HandleCooldowns,
    HandleCombat = HandleCombat,
    HandleGems = HandleGems,
    HandleMez = HandleMez,
    HandlePulls = HandlePulls,
    HandleRecover = HandleRecover,
    HandleNextAbility = HandleNextAbility
}
