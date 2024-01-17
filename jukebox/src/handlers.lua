local songScheduler         = GemsScheduler.new()
local AbilityScheduler      = AbilityScheduler.new()
local BossScheduler         = AbilityScheduler.new()

local AbilityCheckDelay     = Timer.new(UserSettings.ManageCoPilot.CoolDownDelay, false, 'Ability Check Delay')
local BossCheckDelay        = Timer.new(UserSettings.ManageCoPilot.CoolDownDelay, false, 'Boss Check Delay')
local CopilotCheckDelay     = Timer.new(1, false, 'CoPilot Check Delay')
local callDelayTimer        = Timer.new(0.75)

AbilityCheckDelay:start()
CopilotCheckDelay:start()
callDelayTimer:start()

---------------------------------------------------
-- Variables
---------------------------------------------------
local ChestSlot = tostring(mq.TLO.Me.Inventory(17).ID())               -- The ID of the item in the chest slot.
local HasReset = true

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

local function HandleCooldowns()
    -- Boss Handling
    if Helpers.CheckCombat() and BossCheckDelay:hasExpired() and mq.TLO.Target.Named() then
        if UserSettings.ManageCoPilot.BurnBoss then
            BossCheckDelay = Timer.new(0.25, false, 'Burn Boss Timer')
        else
            BossCheckDelay = Timer.new(UserSettings.ManageCoPilot.CoolDownDelay, false, 'Boss Check Delay')
        end

        BossCheckDelay:start()

        local abilities = {
            {name = 'Fierce Eye',               boss = UserSettings.ManageCoPilot.Ability.FierceEye.Trash},
            {name = 'Quick Time',               boss = UserSettings.ManageCoPilot.Ability.QuickTime.Trash},
            {name = 'Cacophony',                boss = UserSettings.ManageCoPilot.Ability.Cacophony.Trash},
            {name = 'Lyrical Prankster',        boss = UserSettings.ManageCoPilot.Ability.LyricalPrankster.Trash},
            {name = 'Song of Stone',            boss = UserSettings.ManageCoPilot.Ability.SongofStone.Trash},
            {name = 'Bladed Song',              boss = UserSettings.ManageCoPilot.Ability.BladedSong.Trash},
            {name = 'Spire of the Minstrels',   boss = UserSettings.ManageCoPilot.Ability.SpireoftheMinstrels.Trash},
            {name = 'Funeral Dirge',            boss = UserSettings.ManageCoPilot.Ability.FuneralDirge.Trash},
            {name = 'Flurry of Notes',          boss = UserSettings.ManageCoPilot.Ability.FlurryofNotes.Trash},
            {name = 'Frenzied Kicks',           boss = UserSettings.ManageCoPilot.Ability.FrenziedKicks.Trash},
            {name = 'Dance of Blades',          boss = UserSettings.ManageCoPilot.Ability.DanceofBlades.Trash},
            {name = 'Shield of Notes',          boss = UserSettings.ManageCoPilot.Ability.ShieldofNotes.Trash}
        }

        -- Checks if an ability is ready and not already in the queue, and adds it to the queue if it passes these checks.
        -- @param ability (string) The name of the ability to check.
        -- Checks if an ability is ready and not already in the queue, and adds it to the queue if it passes these checks.
        -- @param ability (string) The name of the ability to check.
        function QueueAbilityIfReady(ability)
            if ability and ability.name and ability.boss then
                local status, error = pcall(function()
                    if not BossScheduler:isAbilityOnCooldown(ability.name) and not BossScheduler:isAbilityInQueue(ability.name) then
                        BossScheduler:addAbilityToQueue(ability.name)
                    end
                end)
                if not status then
                    print("Error queuing ability " .. ability.name .. ": "  .. error)
                end
            else
                print("Attempted to queue nil ability or ability is not enabled in UserSettings")
            end
        end

        for _, ability in ipairs(abilities) do
            local status, error = pcall(function() QueueAbilityIfReady(ability) end)
            if not status then
                print("Error queuing ability: " .. error)
            end
        end

        BossScheduler:castNextAbility()
    end

    -- Trash Handling
    if Helpers.CheckCombat() and AbilityCheckDelay:hasExpired() and not mq.TLO.Target.Named() then
        AbilityCheckDelay:start()
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

        -- Checks if an ability is ready and not already in the queue, and adds it to the queue if it passes these checks.
        -- @param ability (string) The name of the ability to check.
        -- Checks if an ability is ready and not already in the queue, and adds it to the queue if it passes these checks.
        -- @param ability (string) The name of the ability to check.
        function QueueAbilityIfReady(ability)
            if ability and ability.name and ability.trash then
                local status, error = pcall(function()
                    if not AbilityScheduler:isAbilityOnCooldown(ability.name) and not AbilityScheduler:isAbilityInQueue(ability.name) then
                        AbilityScheduler:addAbilityToQueue(ability.name)
                    end
                end)
                if not status then
                    if UserSettings.Debug then print("Error queuing ability " .. ability.name .. ": "  .. error) end
                end
            else
                if UserSettings.Debug then print("Attempted to queue nil ability or ability is not enabled in UserSettings: " .. ability.name) end
            end
        end

        for _, ability in ipairs(abilities) do
            local status, error = pcall(function() QueueAbilityIfReady(ability) end)
            if not status then
                if UserSettings.Debug then print("Error queuing ability: " .. error) end
            end
        end

        AbilityScheduler:castNextAbility()
    elseif not Helpers.CheckCombat() then
        AbilityScheduler:clearAbilityQueue()
    end
end

local function HandleCombat()
    local AssistRange = UserSettings.ManageCombat.AssistRange + math.random(-UserSettings.ManageCombat.AssistRangeScatter, UserSettings.ManageCombat.AssistRangeScatter)
    local AssistPct = UserSettings.ManageCombat.AssistPct + math.random(-UserSettings.ManageCombat.AssistPctScatter, UserSettings.ManageCombat.AssistPctScatter)
    local TempCampX = CampLocationX + math.random(-UserSettings.ManageCombat.CampScatter, UserSettings.ManageCombat.CampScatter)
    local TempCampY = CampLocationY + math.random(-UserSettings.ManageCombat.CampScatter, UserSettings.ManageCombat.CampScatter)

    if UserSettings.Debug then print("Assist Range: " .. tostring(AssistRange) .. ' Assist Percent:' .. tostring(AssistPct)) end

    local function AcquireTarget()
        if mq.TLO.SpawnCount('npc xtarhater radius ' ..  AssistRange)() > 0 then
            if mq.TLO.Group.MainAssist.ID() ~= nil then 
                mq.cmd('/assist ' .. mq.TLO.Group.MainAssist.Name())
            elseif mq.TLO.Group.MainTank.ID() ~= nil then 
                mq.cmd('/assist ' .. mq.TLO.Group.MainTank.Name())
            else
                ConsoleHistory:addMessage('No Main Assist or Main Tank found, please set one.')
            end
        end
    end

    local function EngageTarget()
        if mq.TLO.Target.ID() > 0 then
            if not mq.TLO.Stick.Active() then
                mq.cmd('/squelch /face')
                mq.cmd('/squelch /stick behind')
                mq.cmd('/squelch /attack on')
                ConsoleHistory:addMessage('Engaging: ' .. mq.TLO.Target.Name())
            end
        end
    end

    local function MakeCamp()
        mq.cmd('/squelch /target clear')
        mq.cmd('/squelch /attack off')
        mq.cmd('/squelch /nav locyx ' .. TempCampY .. " " .. TempCampX)
        ConsoleHistory:addMessage("Camping at: " .. TempCampY .. " " .. TempCampX)
    end

    local function BackOff()
        mq.cmd('/squelch /target clear')
        mq.cmd('/squelch /attack off')
        mq.cmd('/aa act Fading Memories')
        MakeCamp()
        ConsoleHistory:addMessage('HP is Low - Backing Off')
    end

    AcquireTarget()

    if Helpers.CheckXTargetList() and mq.TLO.Target.Distance() <= AssistRange and mq.TLO.Target.PctHPs() <= AssistPct  then
        EngageTarget()
        HasReset = false
    end

    if UserSettings.ManageCombat.UseCamp and not HasReset and not Helpers.CheckCombat() and not Helpers.CheckXTargetList() then
        MakeCamp()
        HasReset = true
    end

    if UserSettings.ManageCombat.BackOff and mq.TLO.Me.PctHPs() <= UserSettings.ManageCombat.BackOffPct then
        BackOff()
    end

end

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

local function HandleRecover()
    --todo
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
}
