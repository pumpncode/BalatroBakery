Bakery_API = {}

-- Polyfill __pairs and __ipairs metatables
local raw_pairs = pairs
pairs = function(t)
    local metatable = getmetatable(t)
    if metatable and metatable.__pairs then
        return metatable.__pairs(t)
    end
    return raw_pairs(t)
end

local raw_ipairs = ipairs
ipairs = function(t)
    local metatable = getmetatable(t)
    if metatable and metatable.__ipairs then
        return metatable.__ipairs(t)
    end
    return raw_ipairs(t)
end

sendInfoMessage("pairs() and ipairs() polyfilled", "Bakery")

--- Uses metatables to add a `Length` key to the table which reports the number of keys contained within.
---@param table table @The table to modify.
Bakery_API.sized_table = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return setmetatable({}, {
        __index = function(_, k)
            if k == "Length" then
                return count
            end
            return table[k]
        end,
        __newindex = function(_, k, v)
            if table[k] == nil and v ~= nil then
                count = count + 1
            end
            if table[k] ~= nil and v == nil then
                count = count - 1
            end
            table[k] = v
        end,
        __pairs = function(_)
            return pairs(table)
        end,
        __ipairs = function(_)
            return pairs(table)
        end
    })
end
