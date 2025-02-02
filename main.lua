assert(SMODS.load_file('util.lua'))()

SMODS.Atlas {
    key = "Bakery",
    path = "Bakery.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BakeryTags",
    path = "BakeryTags.png",
    px = 34,
    py = 34
}

local Bakery_retrigger_jokers = Bakery_API.sized_table {
    j_mime = true,
    j_dusk = true,
    j_hack = true,
    j_selzer = true,
    j_sock_and_buskin = true,
    j_hanging_chad = true
}

SMODS.Tag {
    key = "Retrigger",
    atlas = 'BakeryTags',
    pos = {
        x = 0,
        y = 0
    },
    min_ante = 0,
    config = {
        type = 'store_joker_create',
        extra = {}
    },
    loc_vars = function(self, info_queue, card)
        for k in pairs(Bakery_retrigger_jokers) do
            if G.P_CENTERS[k] ~= nil then
                info_queue[#info_queue + 1] = G.P_CENTERS[k]
            end
        end
    end,
    apply = function(self, tag, context) -- 5P1A1QWY
        if not tag.triggered and tag.config.type == context.type then
            tag.triggered = true

            local in_posession = {0}
            for k, v in ipairs(G.jokers.cards) do
                if Bakery_retrigger_jokers[v.config.center.rarity] and not in_posession[v.config.center.key] then
                    in_posession[1] = in_posession[1] + 1
                    in_posession[v.config.center.key] = true
                end
            end

            if Bakery_retrigger_jokers.Length > in_posession[1] then
                local j, k = pseudorandom_element(Bakery_retrigger_jokers, pseudoseed('Retrigger Tag'))
                local card = create_card('Joker', context.area, nil, 2, nil, nil, k, 'Retrigger Tag')
                create_shop_card_ui(card, 'Joker', context.area)
                -- local card = SMODS.create_card {
                --     set = 'Joker',
                --     area = context.area,
                --     key = k
                -- }
                -- create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                return card
            else
                tag:nope()
            end
        end
    end
}

SMODS.Joker {
    key = "Tarmogoyf",
    name = "Tarmogoyf",
    atlas = 'Bakery',
    pos = {
        x = 0,
        y = 0
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            mult = 0,
            mult_gain = 1,
            used_ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult_gain, card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.retrigger_joker and not context.other_card.debuff then
            local rank = context.other_card:get_id()
            if rank > 0 -- Stone cards are random negative ranks
            and card.ability.extra.used_ranks[rank] == nil then
                card.ability.extra.used_ranks[rank] = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = '+' .. (card.ability.extra.mult_gain),
                    colour = G.C.RED,
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult},
                    card = card
                }
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            local flag = card.ability.extra.mult ~= 0
            card.ability.extra.mult = 0
            card.ability.extra.used_ranks = {}
            if flag then
                return {
                    message = 'Reset',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = "Auctioneer",
    name = "Auctioneer",
    atlas = 'Bakery',
    pos = {
        x = 1,
        y = 0
    },
    rarity = 2,
    cost = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            scale = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.scale}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i;
                    break
                end
            end
            if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].ability.eternal and
                not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true

                sliced_card.sell_cost = sliced_card.sell_cost * 3
                sliced_card:sell_card()
            end
        end
    end
}
