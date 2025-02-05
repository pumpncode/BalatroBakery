SMODS.Atlas {
    key = "Bakery",
    path = "Bakery.png",
    px = 71,
    py = 95
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

SMODS.Joker {
    key = "Don",
    name = "Don",
    atlas = 'Bakery',
    pos = {
        x = 2,
        y = 0
    },
    rarity = 3,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            x_mult = 3,
            cost = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.x_mult, card.ability.extra.cost}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult,
                dollars = -card.ability.extra.cost
            }
        end
    end
}

SMODS.Joker {
    key = "Werewolf",
    name = "Werewolf",
    atlas = 'Bakery',
    rarity = 3,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            front = 2,
            back = 3,
            flipped = false,
            discards = 0,
            front_pos = {
                x = 3,
                y = 0
            },
            back_pos = {
                x = 4,
                y = 0
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {self.key == "j_Bakery_Werewolf_Back" and card.ability.extra.back or card.ability.extra.front}
        }
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card and card.ability.extra.flipped then
            self.key = "j_Bakery_Werewolf_Back"
        end
        SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        info_queue[#info_queue + 1] = {
            generate_ui = function(_self, _info_queue, _card, _desc_nodes, _specific_vars, _full_UI_table)
                if not card or not card.ability.extra.flipped then
                    self.key = "j_Bakery_Werewolf_Back"
                end
                SMODS.Joker.generate_ui(self, _info_queue, _card, _desc_nodes, _specific_vars, _full_UI_table)
                self.key = key
            end
        }
        self.key = key
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.discards = card.ability.extra.discards + 1
        end

        if context.joker_main then
            return {
                x_mult = card.ability.extra.flipped and card.ability.extra.back or card.ability.extra.front
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if (card.ability.extra.flipped and card.ability.extra.discards >= 2) or
                (not card.ability.extra.flipped and card.ability.extra.discards == 0) then
                Bakery_API.flip_double_sided(card)
            end
            card.ability.extra.discards = 0
        end
    end
}
