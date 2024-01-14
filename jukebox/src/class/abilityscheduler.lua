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
    self.abilityDelayTimer = Timer.new(duration or 1, false, "AbilityScheduler", nil) -- Use the provided duration or default to 1
    return self
end

-- Adds an ability to the ability queue.
-- @param ability (string) The name of the ability to add.
function AbilityScheduler:addAbilityToQueue(ability)
    table.insert(self.abilityQueue, ability)
end

-- Checks if an ability is already in the queue.
-- @param ability (string) The name of the ability to check.
-- @return (boolean) True if the ability is in the queue, false otherwise.
function AbilityScheduler:isAbilityInQueue(ability)
    for _, queuedAbility in ipairs(self.abilityQueue) do
        if queuedAbility == ability then
            return true
        end
    end
    return false
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

-- Removes all instances of an ability from the queue if it's on cooldown.
-- @param ability (string) The name of the ability to check.
function AbilityScheduler:removeAbilityFromQueueIfOnCooldown(ability)
    if self:isAbilityOnCooldown(ability) then
        for i = #self.abilityQueue, 1, -1 do
            if self.abilityQueue[i] == ability then
                table.remove(self.abilityQueue, i)
            end
        end
    end
end

-- Casts the next ability in the ability queue if the delay timer has expired and the ability is not on cooldown.
function AbilityScheduler:castNextAbility()
    if #self.abilityQueue > 0 and self.abilityDelayTimer:hasExpired() and Helpers.CheckCombat() then
        local ability = self.abilityQueue[1] -- Get the next ability without removing it from the queue

        --print("Ability Ready: " .. ability .. " (" .. tostring(self.isAbilityOnCooldown(ability)) .. ")")

        -- Remove the ability from the queue if it's on cooldown
        self:removeAbilityFromQueueIfOnCooldown(ability)

        -- If the ability is still in the queue, it's not on cooldown and can be cast
        if self:isAbilityInQueue(ability) then
            -- Remove the ability from the queue
            table.remove(self.abilityQueue, 1)

            ConsoleHistory:addMessage('Casting ' .. ability)
            local status, error = pcall(function() mq.cmd('/aa act ' .. ability) end)
            if not status then
                print("Error casting ability: " .. error)
            end

            self.abilityDelayTimer:start()
        end
    end
end

return AbilityScheduler
