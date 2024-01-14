--- @type Mq
local mq = require('mq')

---------------------------------------------------
-- Helper Functions
---------------------------------------------------
--  checkXTargetList function:
--  Recursively checks if the targeted mob is anywhere on your extended target window.
--
--  Returns:
--   - true if the targeted mob is found in the extended target window
--   - false otherwise
local function CheckXTargetList()
    -- Recursively checks if the targeted mob is anywhere on your extended target window.
    if mq.TLO.Target.ID() ~= 0 then
        for i = 1, 23 do
            if mq.TLO.Me.XTarget(i).ID == mq.TLO.Target.ID then
                return true
            end
        end
        return false
    end
end

--    checkCombat function:
--    Checks if the player is in combat, the target's distance and health percentage are valid,
--    and if the targeted mob is in the extended target window.
--
--    Returns:
--    - true if all conditions are met
--    - false otherwise
local function CheckCombat()
    if mq.TLO.Me.Combat() and mq.TLO.Target.Distance ~= nil and mq.TLO.Target.PctHPs ~= nil and CheckXTargetList() then
        if mq.TLO.Target.PctHPs() <= 99 and mq.TLO.Target.Distance() <= 150 then
            return true
        end
    end
    return false
end

-- Splits a string into a table of substrings based on a delimiter.
-- @param str The string to be split.
-- @param delimiter The delimiter used to split the string.
-- @return A table containing the substrings.
local function Split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    str:gsub(pattern, function(value) result[#result + 1] = value end)
    return result
end

-- Retrieves a value from a nested table using a dot-separated key.
-- If the key contains dots, it recursively traverses the nested tables until the final value is found.
-- If the key is not found, it returns nil.
-- @param t table: The table to search in.
-- @param key string: The dot-separated key to retrieve the value.
-- @return any: The value associated with the key, or nil if not found.
local function getNestedTable(t, key)
    local i = key:find('%.')
    if i then
        local key_part = key:sub(1, i - 1)
        local rest = key:sub(i + 1)
        if t[key_part] then
            return getNestedTable(t[key_part], rest)
        else
            return nil
        end
    else
        return t[key]
    end
end

-- Sets a value in a nested table using dot notation for the key.
-- If the key contains dots, it creates intermediate tables as needed.
-- @param t table: The table to set the value in.
-- @param key string: The key in dot notation.
-- @param value any: The value to set.
local function setNestedTable(t, key, value)
    local i = key:find('%.')
    if i then
        local key_part = key:sub(1, i - 1)
        local rest = key:sub(i + 1)
        if not t[key_part] then
            t[key_part] = {}
        end
        setNestedTable(t[key_part], rest, value)
    else
        t[key] = value
    end
end
---------------------------------------------------
-- Path: helpers.lua
---------------------------------------------------

return {
    CheckXTargetList = CheckXTargetList,
    CheckCombat = CheckCombat,
    Split = Split,
    getNestedTable = getNestedTable,
    setNestedTable = setNestedTable
}
