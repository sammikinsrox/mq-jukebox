---------------------------------------------------
-- ConsoleHistory Class
---------------------------------------------------
-- Represents a console history object.
-- @class ConsoleHistory
-- @field history table The history of messages.

ConsoleHistory = {}
ConsoleHistory.__index = ConsoleHistory

-- Constructor for ConsoleHistory.
-- @return ConsoleHistory The newly created ConsoleHistory object.
function ConsoleHistory.new()
    local self = setmetatable({}, ConsoleHistory)
    self.history = {}
    return self
end

-- Adds a new message to the history.
-- @param message string The message to add.
function ConsoleHistory:addMessage(message)
    local timestamp = os.date('%H:%M:%S', os.time())
    table.insert(self.history, {message = message, timestamp = timestamp})

    -- If the history exceeds 100 messages, remove the oldest one
    if #self.history > 30 then
        table.remove(self.history, 1)
    end
end

-- Displays the entire history.
function ConsoleHistory:display()
    if ImGui.Button("Clear History") then
        self:clearHistory()
    end
    for i, entry in ipairs(self.history) do
        -- change color of text to yellow
        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 0, 1)
        ImGui.BulletText(entry.timestamp .. ": ")
        ImGui.PopStyleColor()
        ImGui.SameLine()
        ImGui.Text(entry.message)
    end
end

-- Clears the entire history.
function ConsoleHistory:clearHistory()
    self.history = {}
end

return ConsoleHistory