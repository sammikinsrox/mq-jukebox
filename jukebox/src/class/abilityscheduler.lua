Timer = require('src.class.timer')

--------------------------------------------------
-- Ability Scheduler
-- This is a scheduler for copilot abilities,
-- to keep them from spamming.
---------------------------------------------------
-- AbilityScheduler class for managing the scheduling and casting of abilities.
AbilityScheduler = {}
AbilityScheduler.__index = AbilityScheduler

-- Creates a new instance of AbilityScheduler.
-- @param duration (number) The duration of the ability delay timer. Defaults to 1 if not provided.
-- @return (table) The new AbilityScheduler instance.
function AbilityScheduler.new(duration)
    local self = setmetatable({}, AbilityScheduler)
    self.abilityQueue = {}
    self.abilityDelayTimer = Timer.new(duration or 1) -- Use the provided duration or default to 1
    return self
end

-- Adds an ability to the ability queue.
-- @param ability (string) The name of the ability to add.
function AbilityScheduler:addAbilityToQueue(ability)
    table.insert(self.abilityQueue, ability)
end

-- Checks if an ability is on cooldown.
-- @param ability (string) The name of the ability to check.
-- @return (boolean) True if the ability is on cooldown, false otherwise.
function AbilityScheduler:isAbilityOnCooldown(ability)
    if mq.TLO.Me.AltAbilityReady(ability)() then
        return false
    else
        return true
    end
end

-- Casts the next ability in the ability queue if the delay timer has expired and the ability is not on cooldown.
function AbilityScheduler:castNextAbility()
    if #self.abilityQueue > 0 and self.abilityDelayTimer:hasExpired() and Helpers.CheckCombat() then
        local ability = table.remove(self.abilityQueue, 1)
        if not self:isAbilityOnCooldown(ability) then
            ConsoleHistory:addMessage('Casting ' .. ability)
            local status, error = pcall(function() mq.cmd('/aa act ' .. ability) end)
            if not status then
                print("Error casting ability: " .. error)
            end
            if mq.TLO.Target.Named() and UserSettings.ManageCoPilot.BurnBoss then
                self.abilityDelayTimer:start()
            else
                self.abilityDelayTimer:start(UserSettings.ManageCoPilot.CoolDownDelay)
            end
        end
    end
end

return AbilityScheduler