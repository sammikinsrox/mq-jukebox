-- GemsScheduler class represents a scheduler for playing songs using gems.
-- It manages combat songs and resting songs, and provides methods to play, stop, and cast gems.
-- The class also includes a timer to automatically cast the next gem in the song sequence.
local GemsScheduler = {}
GemsScheduler.__index = GemsScheduler

-- Creates a new instance of GemsScheduler.
-- If UserSettings and UserSettings.ManageGems are available, it initializes the combatSongs and restingSongs with the corresponding values.
-- Otherwise, it initializes them as empty tables.
-- It also sets the initial state of playing combat songs and resting songs to false.
-- The songs table and currentSongIndex are initialized as empty and 1 respectively.
-- @return The newly created GemsScheduler instance.
function GemsScheduler.new()
    local self = setmetatable({}, GemsScheduler)
    if UserSettings and UserSettings.ManageGems then
        self.combatSongs = UserSettings.ManageGems.TwistCombat or {}
        self.restingSongs = UserSettings.ManageGems.TwistResting or {}
    else
        print("Error: UserSettings or ManageGems is nil")
        self.combatSongs = {}
        self.restingSongs = {}
    end
    self.isPlayingCombatSongs = false
    self.isPlayingRestingSongs = false
    self.songs = {}
    self.currentSongIndex = 1
    return self
end

-- Plays the combat songs.
-- If resting songs are currently playing, it stops them first.
function GemsScheduler:playCombatSongs()
    if self.isPlayingRestingSongs then
        self:stopRestingSongs()
    end
    self.isPlayingCombatSongs = true
    self:playSongs(self.combatSongs)
end

-- Plays the resting songs.
-- If combat songs are currently playing, it stops them first.
function GemsScheduler:playRestingSongs()
    if self.isPlayingCombatSongs then
        self:stopCombatSongs()
    end
    self.isPlayingRestingSongs = true
    self:playSongs(self.restingSongs)
end

-- Stops playing combat songs.
function GemsScheduler:stopCombatSongs()
    self.isPlayingCombatSongs = false
    self.currentSongIndex = 1
end

-- Stops playing resting songs.
function GemsScheduler:stopRestingSongs()
    self.isPlayingRestingSongs = false
    self.currentSongIndex = 1
end

-- Checks if a gem is valid.
-- A gem is considered valid if it is a number between 1 and 13 (inclusive).
-- @param gem The gem to check.
-- @return True if the gem is valid, false otherwise.
function GemsScheduler:isValidGem(gem)
    return gem and type(gem) == "number" and gem >= 1 and gem <= 13
end

-- Plays a sequence of songs.
-- It sets the songs table to the provided songs parameter and calls the castNextGem method to start casting the first gem.
-- If the songs parameter is not a table, it prints an error message.
-- @param songs The table of songs to play.
function GemsScheduler:playSongs(songs)
    if songs and type(songs) == "table" then
        self.songs = songs
        self:castNextGem()
    else
        print("Error: Invalid songs list")
    end
end

-- Casts a gem.
-- If the cast time left is less than or equal to 4000 milliseconds, it casts the gem immediately.
-- If the cast time left is greater than 400000000 milliseconds, it stops the current cast and casts the gem.
-- If the cast time left is 0, it casts the gem.
-- @param gem The gem to cast.
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

-- Casts the next gem in the song sequence.
-- If there is an ongoing cast, it stops it first.
-- If there are more gems in the sequence, it casts the next gem and increments the currentSongIndex.
-- If the currentSongIndex exceeds the number of gems in the sequence, it resets it to 1.
-- It also starts a timer to call the castNextGem method after 1 second.
function GemsScheduler:castNextGem()
    if mq.TLO.Me.CastTimeLeft() > 0 then
        mq.cmd('/stopcast')
    end
    while self.currentSongIndex <= #self.songs do
        local gem = self.songs[self.currentSongIndex]
        if gem ~= nil then
            if self:isValidGem(gem) then
                self:castGem(gem)
                self.currentSongIndex = self.currentSongIndex + 1
                break
            else
                print("Invalid gem: " .. tostring(gem))
                self.currentSongIndex = self.currentSongIndex + 1
            end
        else
            self.currentSongIndex = self.currentSongIndex + 1
        end
    end
    if self.currentSongIndex > #self.songs then
        self.currentSongIndex = 1
    end
    Timer.new(1, function()
        self:castNextGem()
    end):start()
end

return GemsScheduler