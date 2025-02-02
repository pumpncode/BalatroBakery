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

-- Polyfill a tag trigger when scoring
-- This is a bit of a hack (it retriggers 2s, 3s, 4s, and 5s), but it should work.
local raw_modify_hand = Blind.modify_hand
local animations = {}
local last_mult, last_chips, last_mod
function Blind:modify_hand(cards, poker_hands, text, mult, hand_chips)
    local mult, chips, mod = raw_modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    last_mult = mod_mult(mult)
    last_chips = mod_chips(chips)
    last_mod = mod
    for i = 1, #G.GAME.tags do
        local ret = G.GAME.tags[i]:apply_to_run({
            type = 'play_hand_early'
        })
        if ret then
            mult = mod_mult(mult + (ret.mult or 0))
            chips = mod_chips(chips + (ret.chips or 0))
            table.insert(animations, {
                d_mult = ret.mult or 0,
                mult = mult,
                d_chips = ret.chips or 0,
                chips = chips,
                card = ret.card or G.GAME.tags[i],
                after = ret.after
            })
        end
    end
    return mult, chips, mod or (#animations > 0)
end

local real_raw_update_hand_text = update_hand_text
local raw_update_hand_text = function(a, b)
    real_raw_update_hand_text(a, b)
end
function update_hand_text(config, vals)
    if #animations > 0 then
        config.modded = last_mod
        vals.chips = last_chips
        vals.mult = last_mult
    end

    raw_update_hand_text(config, vals)

    for i = 1, #animations do
        local anim = animations[i]
        local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims
        if anim.d_chips ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            raw_update_hand_text({
                delay = 0
            }, {
                chips = anim.chips
            })
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.75,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_chips',
                                vars = {anim.d_chips}
                            },
                            hold = 0.55,
                            backdrop_colour = G.C.CHIPS,
                            major = anim.card.HUD_tag
                        }
                        play_sound('chips1', 0.845 + 0.04 * math.random(), 1)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.d_mult ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            raw_update_hand_text({
                delay = 0
            }, {
                mult = anim.mult
            })
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_mult',
                                vars = {anim.d_mult}
                            },
                            scale = 0.7,
                            hold = 0.6125,
                            backdrop_colour = G.C.MULT,
                            major = anim.card.HUD_tag
                        }
                        play_sound('multhit1', 0.845 + 0.04 * math.random(), 1)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.after then
            anim.after()
        end
    end

    animations = {}
end

sendInfoMessage("Blind:modify_hand() and update_hand_text() polyfilled", "Bakery")

--- Uses metatables to add a `Length` key to the table which reports the number of keys contained within.
---@param table table @The table to modify.
function Bakery_API.sized_table(table)
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
