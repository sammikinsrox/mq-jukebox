local GemsScheduler = {}
GemsScheduler.__index = GemsScheduler

--- Creates a new instance of GemsScheduler.
-- @return GemsScheduler object
function GemsScheduler.new()
    local self = setmetatable({}, GemsScheduler)
    self.combatSongs = UserSettings.ManageGems.TwistCombat
    self.restingSongs = UserSettings.ManageGems.TwistResting
    self.isPlayingCombatSongs = false
    self.isPlayingRestingSongs = false
    self.songs = {}
    self.currentSongIndex = 1
    return self
end

--- Plays combat songs.
function GemsScheduler:playCombatSongs()
    if self.isPlayingRestingSongs then
        self:stopRestingSongs()
    end
    self.isPlayingCombatSongs = true
    self:playSongs(self.combatSongs)
end

--- Plays the resting songs.
function GemsScheduler:playRestingSongs()
    if self.isPlayingCombatSongs then
        self:stopCombatSongs()
    end
    self.isPlayingRestingSongs = true
    self:playSongs(self.restingSongs)
end

--- Stops the combat songs and resets the current song index.
function GemsScheduler:stopCombatSongs()
    self.isPlayingCombatSongs = false
    self.currentSongIndex = 1
end

--- Stops the resting songs and resets the current song index.
function GemsScheduler:stopRestingSongs()
    self.isPlayingRestingSongs = false
    self.currentSongIndex = 1
end

--- Checks if a gem is valid.
-- @param gem The gem to check.
-- @return True if the gem is valid, false otherwise.
function GemsScheduler:isValidGem(gem)
    return gem >= 1 and gem <= 13
end

--- Plays a list of songs using the GemsScheduler.
--- @param songs table The list of songs to be played.
function GemsScheduler:playSongs(songs)
    self.songs = songs
    self:castNextGem()
end

--- Casts a gem based on the remaining cast time.
--- If the cast time is less than or equal to 4000 milliseconds, it casts the gem immediately.
--- If the cast time is greater than 400000000 milliseconds, it stops the current cast and casts the gem.
--- If the cast time is 0 milliseconds, it casts the gem.
---@param gem string The name of the gem to cast.
function GemsScheduler:castGem(gem)
    local castTimeLeft = mq.TLO.Me.CastTimeLeft()
    if castTimeLeft <= 4000 then
        mq.cmd('/cast ' .. gem)
    elseif castTimeLeft > 400000000 then
        mq.cmd('/stopcast')
        mq.cmd('/cast ' .. gem)
    elseif castTimeLeft == 0 then
        mq.cmd('/cast ' .. gem)
    end
end

--- Casts the next gem in the gem scheduler.
function GemsScheduler:castNextGem()
    if mq.TLO.Me.CastTimeLeft() > 0 then
        mq.cmd('/stopcast')
    end
    if self.currentSongIndex <= #self.songs then
        local gem = self.songs[self.currentSongIndex]
        if self:isValidGem(gem) then
            self:castGem(gem)
            self.currentSongIndex = self.currentSongIndex + 1
        else
            print("Invalid gem: " .. tostring(gem))
        end
    else
        self.currentSongIndex = 1
    end
    Timer.new(1, function()
        self:castNextGem()
    end):start()
end

return GemsScheduler