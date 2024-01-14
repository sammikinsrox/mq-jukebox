local Timer = {}
Timer.__index = Timer

function Timer.new(delay, repeating, name, callback)
    local self = setmetatable({}, Timer)
    self.startTime = os.time()
    self.delay = delay
    self.repeating = repeating or false
    self.name = name or "Unnamed Timer"
    self.callback = callback or nil
    self.timerActive = true
    return self
end

function Timer:start()
    self.startTime = os.time()
    self.timerActive = true
end

function Timer:stop()
    self.timerActive = false
end

function Timer:hasExpired()
    if not self.timerActive then
        return false
    end

    local currentTime = os.time()
    if currentTime - self.startTime >= self.delay then
        if self.callback then
            local status, err = pcall(self.callback)
            if not status then
                print("Error in callback function: ", err)
            end
        end

        if self.repeating then
            self.startTime = currentTime
        else
            self.timerActive = false
        end

        return true
    else
        return false
    end
end

return Timer