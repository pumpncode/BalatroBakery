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

sendInfoMessage("pairs() and ipairs() patched. Reason: Convenience", "Bakery")

--- Uses metatables to add a `Length` key to the table which reports the number of keys contained within.
---@param table table @The table to modify.
function Bakery_API.sized_table(table, default_value)
    local count = 0
    local keys = {}
    for k in pairs(table) do
        count = count + 1
        keys[k] = true
    end
    return setmetatable({}, {
        __index = function(_, k)
            if k == "Length" then
                return count
            end
            if keys[k] then
                return table[k]
            else
                return default_value
            end
        end,
        __newindex = function(_, k, v)
            if table[k] == nil and v ~= nil then
                count = count + 1
            end
            if keys[k] and v == nil then
                count = count - 1
            end
            keys[k] = true
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

-- Polyfill a tag trigger when scoring
-- This is a bit of a hack (it retriggers 2s, 3s, 4s, and 5s), but it should work.
local raw_modify_hand = Blind.modify_hand
local raw_update_hand_text = update_hand_text
local raw_back_trigger_effect = Back.trigger_effect
local animations = {}
local last_mult, last_chips, last_mod
function Blind:modify_hand(cards, poker_hands, text, mult, hand_chips)
    local mult, chips, mod = raw_modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    last_mult = mod_mult(mult)
    last_chips = mod_chips(chips)
    last_mod = mod

    local function apply(ret, default_card)
        if not ret then
            return
        end
        mult = mod_mult(mult + (ret.mult or 0))
        mult = mod_mult(mult * (ret.x_mult or 1))
        chips = mod_chips(chips + (ret.chips or 0))
        table.insert(animations, {
            d_mult = ret.mult,
            x_mult = ret.x_mult,
            mult = mult,
            d_chips = ret.chips,
            chips = chips,
            dollars = ret.dollars,
            card = ret.card or default_card,
            after = ret.after
        })
    end

    for i = 1, #G.GAME.tags do
        apply(G.GAME.tags[i]:apply_to_run({
            type = 'play_hand_early'
        }), G.GAME.tags[i])
    end
    return mult, chips, mod or (#animations > 0)
end

local function run_animation(anim)
    local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims
    if anim.d_chips and anim.d_chips ~= 0 then
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
    if anim.d_mult and anim.d_mult ~= 0 then
        if not skip then
            juice_card(anim.card)
        end
        raw_update_hand_text({
            delay = 0
        }, {
            mult = (anim.x_mult and anim.mult / anim.x_mult) or anim.mult
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
    if anim.x_mult and anim.x_mult ~= 0 then
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
                            key = 'a_xmult',
                            vars = {anim.x_mult}
                        },
                        scale = 0.7,
                        hold = 0.6125,
                        backdrop_colour = G.C.XMULT,
                        major = anim.card.HUD_tag
                    }
                    play_sound('multhit2', 0.845 + 0.04 * math.random(), 0.7)
                    anim.card:juice_up(0.6, 0.1)
                    G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                    return true
                end
            }))
        end
    end
    if anim.dollars and anim.dollars ~= 0 then
        if not skip then
            juice_card(anim.card)
        end
        ease_dollars(anim.dollars)
        if not skip then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.8125,
                func = function()
                    attention_text {
                        text = (amt < -0.01 and '-' or '') .. localize("$") .. tostring(math.abs(amt)),
                        scale = 1,
                        hold = 0.6125,
                        backdrop_colour = amt < -0.01 and G.C.RED or G.C.MONEY,
                        major = anim.card.HUD_tag
                    }
                    play_sound('coin3', 0.845 + 0.04 * math.random(), 0.7)
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

function update_hand_text(config, vals)
    if #animations > 0 then
        config.modded = last_mod
        vals.chips = last_chips
        vals.mult = last_mult
    end

    raw_update_hand_text(config, vals)

    for i = 1, #animations do
        run_animation(animations[i])
    end

    animations = {}
end

function Back:trigger_effect(args)
    if args.context == 'final_scoring_step' then
        for i = 1, #G.GAME.tags do
            local ret = G.GAME.tags[i]:apply_to_run({
                type = 'play_hand_late'
            })
            if ret ~= nil then
                args.chips = mod_chips(args.chips + (ret.chips or 0))
                args.mult = mod_mult(args.mult + (ret.mult or 0))
                args.mult = mod_mult(args.mult * (ret.x_mult or 1))
                run_animation({
                    d_mult = ret.mult,
                    x_mult = ret.x_mult,
                    mult = args.mult,
                    d_chips = ret.chips,
                    chips = args.chips,
                    card = ret.card or G.GAME.tags[i],
                    after = ret.after
                })
            end
        end
    end

    local nu_chips, nu_mult = raw_back_trigger_effect(self, args)
    return nu_chips or args.chips, nu_mult or args.mult
end

sendInfoMessage("Blind:modify_hand(), update_hand_text(), and Back:trigger_effect() patched. Reason: Scoring tags",
    "Bakery")

-- Polyfill to render Poly Tag specially
local PolySprite = Sprite:extend()
function PolySprite:draw(overlay)
    Sprite.draw(self, overlay)

    self.ARGS.send_to_shader = self.ARGS.send_to_shader or {}
    self.ARGS.send_to_shader[1] = math.min(self.VT.r * 3, 1) + G.TIMERS.REAL / (28) +
                                      (self.juice and self.juice.r * 20 or 0) + self.tilt_var.amt
    self.ARGS.send_to_shader[2] = G.TIMERS.REAL

    self.tilt_var = self.tilt_var or {
        mx = 0,
        my = 0,
        dx = self.tilt_var.dx or 0,
        dy = self.tilt_var.dy or 0,
        amt = 0
    }
    local tilt_factor = 0.3
    if self.states.focus.is then
        self.tilt_var.mx, self.tilt_var.my =
            G.CONTROLLER.cursor_position.x + self.tilt_var.dx * self.T.w * G.TILESCALE * G.TILESIZE,
            G.CONTROLLER.cursor_position.y + self.tilt_var.dy * self.T.h * G.TILESCALE * G.TILESIZE
        self.tilt_var.amt = math.abs(
            self.hover_offset.y + self.hover_offset.x - 1 + self.tilt_var.dx + self.tilt_var.dy - 1) * tilt_factor
    elseif self.states.hover.is then
        self.tilt_var.mx, self.tilt_var.my = G.CONTROLLER.cursor_position.x, G.CONTROLLER.cursor_position.y
        self.tilt_var.amt = math.abs(self.hover_offset.y + self.hover_offset.x - 1) * tilt_factor
    elseif self.ambient_tilt then
        local tilt_angle = G.TIMERS.REAL * (1.56 + (self.ID / 1.14212) % 1) + self.ID / 1.35122
        self.tilt_var.mx =
            ((0.5 + 0.5 * self.ambient_tilt * math.cos(tilt_angle)) * self.VT.w + self.VT.x + G.ROOM.T.x) * G.TILESIZE *
                G.TILESCALE
        self.tilt_var.my =
            ((0.5 + 0.5 * self.ambient_tilt * math.sin(tilt_angle)) * self.VT.h + self.VT.y + G.ROOM.T.y) * G.TILESIZE *
                G.TILESCALE
        self.tilt_var.amt = self.ambient_tilt * (0.5 + math.cos(tilt_angle)) * tilt_factor
    end

    self:draw_shader('polychrome', nil, self.ARGS.send_to_shader)
end

local PolyTag = Tag:extend()
function PolyTag:generate_UI(_size)
    local tag_sprite_tab, tag_sprite = Tag.generate_UI(self, _size)
    tag_sprite.tilt_var = {
        mx = 0,
        my = 0,
        dx = 0,
        dy = 0,
        amt = 0
    }
    setmetatable(tag_sprite, PolySprite)
    return tag_sprite_tab, tag_sprite
end

local raw_Tag_load = Tag.load
function Tag:load(tbl)
    raw_Tag_load(self, tbl)
    if tbl.key == "tag_Bakery_PolyTag" then
        setmetatable(self, PolyTag)
    end
end

local raw_Object_call = Object.__call
function Object:__call(...)
    local arg = {...}
    if self == Tag and arg[1] == "tag_Bakery_PolyTag" then
        return raw_Object_call(PolyTag, ...)
    end
    return raw_Object_call(self, ...)
end

sendInfoMessage("Object:__call() and Tag:load() patched. Reason: Rendering Poly Tag", "Bakery")

-- Maps the keys of Blinds to how many times they've been defeated this session.
Bakery_API.defeated_blinds = Bakery_API.sized_table({}, 0)

local raw_Blind_defeat = Blind.defeat
function Blind:defeat(silent)
    raw_Blind_defeat(self, silent)
    Bakery_API.defeated_blinds[self.config.blind.key] = Bakery_API.defeated_blinds[self.config.blind.key] + 1
end
local raw_G_FUNCS_load_profile = G.FUNCS.load_profile
G.FUNCS.load_profile = function(...)
    Bakery_API.defeated_blinds = Bakery_API.sized_table({}, 0)
    raw_G_FUNCS_load_profile(...)
end

sendInfoMessage("Blind:defeat() and G.FUNCS.load_profile() patched. Reason: Unlock conditions", "Bakery")

-- Any deck or card sleeve whose key is true in this table will receive no money from any source.
Bakery_API.no_money_decks = Bakery_API.sized_table {
    b_Bakery_Credit = true,
    sleeve_Bakery_Credit = true
}

local raw_ease_dollars = ease_dollars
function ease_dollars(mod, instant)
    if mod <= 0 or (not Bakery_API.no_money_decks[G.GAME.selected_back_key.key or G.GAME.selected_back_key] and
        not Bakery_API.no_money_decks[G.GAME.selected_sleeve]) then
        return raw_ease_dollars(mod, instant)
    end

    local function _mod()
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
        attention_text({
            text = localize('k_nope_ex'),
            scale = 0.8,
            hold = 0.7,
            cover = dollar_UI.parent,
            cover_colour = G.C.RED,
            align = 'cm',
            silent = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.06 * G.SETTINGS.GAMESPEED,
            blockable = false,
            blocking = false,
            func = function()
                play_sound('tarot2', 0.76, 0.4);
                return true
            end
        }))
        play_sound('tarot2', 1, 0.4)
    end
    if instant then
        _mod()
    else
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                _mod()
                return true
            end
        }))
    end
end

sendInfoMessage("ease_dollars() patched. Reason: Credit Deck", "Bakery")

local raw_Blind_press_play = Blind.press_play
function Blind:press_play()
    raw_Blind_press_play(self)

    local sleeve = CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    if sleeve and type(sleeve.calculate) == "function" then
        sleeve:calculate(sleeve, {
            context = 'Bakery_after_press_play'
        })
    end
end

sendInfoMessage("Blind:press_play() patched. Reason: Credit Deck + Credit Sleeve", "Bakery")

-- Any card whose center's key is true in this table will be rendered double sided.
-- The front sprite of the card should be specified in `config.extra.front_pos`, and the back in `config.extra.back_pos`.
-- `config.extra.flipped` will be indicate whether the card has been flipped with `Bakery_API.flip_double_sided(card)`.
-- `config.extra.flipped` does NOT include effects like Amber Acorn.
Bakery_API.double_sided_jokers = Bakery_API.sized_table {
    j_Bakery_Werewolf = true
}

-- Flips a double-sided card.
function Bakery_API.flip_double_sided(card)
    G.E_MANAGER:add_event(Event{
        trigger = 'before',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            play_sound('card1')
            card.pinch.x = true
            card.flipping = nil
            return true
        end
    })
    G.E_MANAGER:add_event(Event{
        trigger='immediate',
        func = function()
            if card.VT.w <= 0 then
                card.pinch.x = false
                card.ability.extra.flipped = not card.ability.extra.flipped
                return true
            end
            return false
        end
    })
    G.E_MANAGER:add_event(Event{
        trigger='immediate',
        blocking = false,
        func = function()
            if card.VT.w >= card.T.w then
                play_sound('tarot2')
                card:juice_up(0.3, 0.3)
                return true
            end
            return false
        end
    })
end

local raw_Card_draw = Card.draw
function Card:draw(layer)
    if self.config.center and Bakery_API.double_sided_jokers[self.config.center.key] then
        local sprite_facing = self.sprite_facing
        self.sprite_facing = "front"
        self.children.center:set_sprite_pos(self.ability.extra.flipped == nil and self.ability.extra.front_pos or
                                                (self.ability.extra.flipped ~= (sprite_facing == "front") and
                                                    self.ability.extra.front_pos or self.ability.extra.back_pos) or {
            x = 0.5,
            y = 0
        })
        raw_Card_draw(self, layer)
        self.sprite_facing = sprite_facing
        return
    end
    raw_Card_draw(self, layer)
end

sendInfoMessage("Card:draw() patched. Reason: Werewolf rendering", "Bakery")
