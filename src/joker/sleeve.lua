local next_key, j_sleeve, no_recurse

local card_area_size = {
    W = 0,
    H = 0,
    X = G.CARD_W * 0.5,
    Y = G.CARD_H * 0.3
}

local CardSleeveCardArea = CardArea:extend()
function CardSleeveCardArea:init(key, major)
    CardSleeveCardArea.super.init(self, 0, 0, card_area_size.W, card_area_size.H, {
        card_limit = 1,
        type = 'Bakery_cardsleeve',
        Bakery_sleeve_key = key
    })
    table.insert(G.I.CARDAREA, self)
    G["Bakery_sleeve_" .. key] = self
    self.role.role_type = 'Minor'
    self.role.major = major
    self.role.offset = {
        x = card_area_size.X,
        y = card_area_size.Y
    }
    self.ARGS.invisible_area_types = self.ARGS.invisible_area_types or {}
    self.ARGS.invisible_area_types.Bakery_cardsleeve = 1
end
function CardSleeveCardArea:draw()
    CardSleeveCardArea.super.draw(self)
    for k, v in ipairs(self.ARGS.draw_layers) do
        for i = 1, #self.cards do
            if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                if G.CONTROLLER.dragging.target ~= self.cards[i] then
                    self.cards[i]:draw(v)
                end
            end
        end
    end
end
function CardSleeveCardArea:can_highlight()
    return true
end
function CardSleeveCardArea:align_cards()
    self.config.type = 'joker'
    CardSleeveCardArea.super.align_cards(self)
    self.config.type = 'Bakery_cardsleeve'
end
function CardSleeveCardArea:remove_card(card)
    local ret = CardSleeveCardArea.super.remove_card(self, card)
    if not no_recurse then
        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.key == j_sleeve.key and v.ability.extra.key == self.config.Bakery_sleeve_key then
                j_sleeve:_remove_card(v)
            end
        end
    end
    return ret
end

j_sleeve = SMODS.Joker {
    key = "CardSleeve",
    name = "CardSleeve",
    atlas = 'Bakery',
    pos = {
        x = 0,
        y = 2
    },
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            occupied = false
        }
    },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.selling_self and card.ability.extra.occupied and not card.ability.extra.override then
            self:_remove_card(card, not self:Bakery_can_use(card))
        end
    end,
    Bakery_can_use = function(self, card)
        if card.ability.extra.occupied then
            return G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE ==
                       G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE ==
                       G.STATES.SMODS_BOOSTER_OPENED
        else
            return not card.ability.extra.override and #G.hand.highlighted == 1
        end
    end,
    _remove_card = function(self, card, to_deck)
        if card.ability.extra.occupied then
            no_recurse = true
            draw_card(G["Bakery_sleeve_" .. card.ability.extra.key], to_deck and G.deck or G.hand, nil, nil, nil,
                G["Bakery_sleeve_" .. card.ability.extra.key].cards[1])
            G.E_MANAGER:add_event(Event {
                trigger = 'immediate',
                func = function()
                    G["Bakery_sleeve_" .. card.ability.extra.key]:remove()
                    G["Bakery_sleeve_" .. card.ability.extra.key] = nil
                    card.ability.extra.key = nil
                    card.ability.extra.occupied = false
                    card.ability.extra.override = nil
                    no_recurse = false
                    card:highlight(card.highlighted)
                    return true
                end
            })
            card.ability.extra.override = true
        end
    end,
    Bakery_use_joker = function(self, card)
        if card.ability.extra.occupied then
            self:_remove_card(card)
        else
            card.ability.extra.key = next_key()
            CardSleeveCardArea(card.ability.extra.key, card)
            draw_card(G.hand, G["Bakery_sleeve_" .. card.ability.extra.key], nil, nil, nil, G.hand.highlighted[1])
            card.ability.extra.occupied = true
            card:highlight(card.highlighted)
        end
    end,
    Bakery_use_button_text = function(self, card)
        return card.ability.extra.occupied and localize('b_Bakery_return') or localize('b_Bakery_store')
    end
}

local function sleevearea_for_key(k)
    for _, v in ipairs(G.I.CARDAREA) do
        if v.config.Bakery_sleeve_key == k then
            return v
        end
    end
end
next_key = function()
    local key = 1
    while sleevearea_for_key(key) do
        key = key + 1
    end
    return key
end

Bakery_API.usable_jokers = {
    j_Bakery_CardSleeve = true
}

local raw_G_UIDEF_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = raw_G_UIDEF_use_and_sell_buttons(card)
    if G.jokers and card.area.config.type == 'joker' and Bakery_API.usable_jokers[card.config.center.key] then
        ret.nodes[1].nodes[2].nodes[1] = {
            n = G.UIT.C,
            config = {
                align = "cr"
            },
            nodes = {{
                n = G.UIT.C,
                config = {
                    ref_table = card,
                    align = "cr",
                    maxw = 1.25,
                    padding = 0.1,
                    r = 0.08,
                    minw = 1.25,
                    minh = 0,
                    hover = true,
                    shadow = true,
                    colour = G.C.UI.BACKGROUND_INACTIVE,
                    one_press = true,
                    button = 'Bakery_use_joker',
                    func = 'Bakery_can_use_joker'
                },
                nodes = {{
                    n = G.UIT.B,
                    config = {
                        w = 0.1,
                        h = 0.6
                    }
                }, {
                    n = G.UIT.T,
                    config = {
                        text = card.config.center.Bakery_use_button_text and
                            card.config.center:Bakery_use_button_text(card) or localize('b_Bakery_store'),
                        colour = G.C.UI.TEXT_LIGHT,
                        scale = 0.55,
                        shadow = true
                    }
                }}
            }}
        }
    end

    return ret
end

local raw_Card_load = Card.load
function Card:load(cardTable, other_card)
    raw_Card_load(self, cardTable, other_card)
    if self.config.center.key == j_sleeve.key and self.ability.extra.key then
        for _, v in ipairs(G.I.CARDAREA) do
            if v.config.Bakery_sleeve_key == self.ability.extra.key then
                self.ability.extra.area = v
                return
            end
        end
    end
end

local raw_Game_start_run = Game.start_run
function Game:start_run(args)
    local todo = {}
    if args.savetext then
        for k, v in pairs(args.savetext.cardAreas) do
            if string.find(k, "^Bakery_sleeve_%d+$") then
                CardSleeveCardArea(tonumber(string.sub(k, 15)))
                todo[k] = G[k]
            end
        end
    end
    local ret = raw_Game_start_run(self, args)
    for k, v in pairs(G.jokers.cards) do
        if v.config.center.key == j_sleeve.key and v.ability.extra.key then
            G["Bakery_sleeve_" .. v.ability.extra.key].role.major = v
            for k, a in ipairs(G.I.CARDAREA) do
                if a == G["Bakery_sleeve_" .. v.ability.extra.key] then
                    table.remove(G.I.CARDAREA, k) -- Render card area in front of joker
                    G.I.CARDAREA[#G.I.CARDAREA + 1] = G["Bakery_sleeve_" .. v.ability.extra.key]
                    break
                end
            end
            todo["Bakery_sleeve_" .. v.ability.extra.key] = nil
        end
    end
    for k, v in pairs(todo) do
        v:remove()
    end
    return ret
end

sendInfoMessage("G.UIDEF.use_and_sell_buttons(), Card:load() and Game:start_run() patched. Reason: Card Sleeve",
    "Bakery")

function G.FUNCS.Bakery_can_use_joker(node)
    local card = node.config.ref_table
    if card and card.config.center.Bakery_can_use and card.config.center:Bakery_can_use(card) then
        node.config.colour = G.C.RED
        node.config.button = 'Bakery_use_joker'
    else
        node.config.colour = G.C.UI.BACKGROUND_INACTIVE
        node.config.button = nil
    end
end
function G.FUNCS.Bakery_use_joker(node)
    local card = node.config.ref_table
    if card and card.config.center.Bakery_use_joker then
        card.config.center:Bakery_use_joker(card)
    end
end

function Bakery_API.get_highlighted()
    local comb = {unpack(G.hand.highlighted)}
    for k, v in ipairs(G.jokers.cards) do
        if v.config.center.key == j_sleeve.key and v.ability.extra.key then
            for k, c in ipairs((sleevearea_for_key(v.ability.extra.key) or {
                highlighted = {}
            }).highlighted) do
                comb[#comb + 1] = c
            end
        end
    end
    return comb
end

function Bakery_API.unhighlight_all()
    G.hand:unhighlight_all()
    for k, v in ipairs(G.jokers.cards) do
        if v.config.center.key == j_sleeve.key and v.ability.extra.key then
            local area = sleevearea_for_key(v.ability.extra.key)
            if area then
                area:unhighlight_all()
            end
        end
    end
end

SMODS.Consumable:take_ownership('strength', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        local highlighted = Bakery_API.get_highlighted()
        for i = 1, #highlighted do
            local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip();
                    play_sound('card1', percent);
                    highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local _card = highlighted[i]
                    local rank_data = SMODS.Ranks[_card.base.value]
                    local behavior = rank_data.strength_effect or {
                        fixed = 1,
                        ignore = false,
                        random = false
                    }
                    local new_rank
                    if behavior.ignore or not next(rank_data.next) then
                        return true
                    elseif behavior.random then
                        new_rank = pseudorandom_element(rank_data.next, pseudoseed('strength'))
                    else
                        local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                        new_rank = rank_data.next[ii]
                    end
                    assert(SMODS.change_base(_card, nil, new_rank))
                    return true
                end
            }))
        end
        for i = 1, #highlighted do
            local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                Bakery_API.unhighlight_all();
                return true
            end
        }))
        delay(0.5)
    end
})
