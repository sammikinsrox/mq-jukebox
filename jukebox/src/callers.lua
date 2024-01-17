local BellowCallTimer = Timer.new(0.5, false, "Bellow Call Timer")
local VaingloriousShoutCallTimer = Timer.new(0.5, false, "Vainglorious Shout Call Timer")
local SelosCallTimer = Timer.new(0.5, false, "Selos Call Timer")
local CooldownCallTimer = Timer.new(0.5, false, "Cooldown Call Timer")
local CombatCallTimer = Timer.new(0.5, false, "Combat Call Timer")
local GemCallTimer = Timer.new(0.5, false, "Gem Call Timer")
local MezCallTimer = Timer.new(0.5, false, "Mez Call Timer")
local PullsCallTimer = Timer.new(0.5, false, "Pulls Call Timer")
local RecoverCallTimer = Timer.new(0.5, false, "Recover Call Timer")

BellowCallTimer:start()
VaingloriousShoutCallTimer:start()
SelosCallTimer:start()
CooldownCallTimer:start()
CombatCallTimer:start()
GemCallTimer:start()
MezCallTimer:start()
PullsCallTimer:start()
RecoverCallTimer:start()

local function CallBellow()
    if BellowCallTimer:hasExpired() then
        Handlers.HandleBellow()
        BellowCallTimer:start()
    end
end

local function CallVaingloriousShout()
    if VaingloriousShoutCallTimer:hasExpired() then
        Handlers.HandleVaingloriousShout()
        VaingloriousShoutCallTimer:start()
    end
end

local function CallSelos()
    if SelosCallTimer:hasExpired() then
        Handlers.HandleSelos()
        SelosCallTimer:start()
    end
end

local function CallCooldown()
    if CooldownCallTimer:hasExpired() then
        Handlers.HandleCooldowns()
        CooldownCallTimer:start()
    end
end

local function CallCombat()
    if CombatCallTimer:hasExpired() then
        Handlers.HandleCombat()
        CombatCallTimer:start()
    end
end

local function CallGem()
    if GemCallTimer:hasExpired() then
        Handlers.HandleGems()
        GemCallTimer:start()
    end
end

local function CallMez()
    if MezCallTimer:hasExpired() then
        Handlers.HandleMez()
        MezCallTimer:start()
    end
end

local function CallPulls()
    if PullsCallTimer:hasExpired() then
        Handlers.HandlePulls()
        PullsCallTimer:start()
    end
end

local function CallRecover()
    if RecoverCallTimer:hasExpired() then
        Handlers.HandleRecover()
        RecoverCallTimer:start()
    end
end

return {
    CallBellow = CallBellow,
    CallVaingloriousShout = CallVaingloriousShout,
    CallSelos = CallSelos,
    CallCooldown = CallCooldown,
    CallCombat = CallCombat,
    CallGem = CallGem,
    CallMez = CallMez,
    CallPulls = CallPulls,
    CallRecover = CallRecover,
}

