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
        if not self or not card or not card.ability or not card.ability.extra then
            return {
                vars = {}
            }
        end
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

local j_spinner = SMODS.Joker {
    key = "Spinner",
    name = "Spinner",
    atlas = 'Bakery',
    pos = {
        x = 5,
        y = 0
    },
    pixel_size = {
        w = 71,
        h = 71
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            effect = {
                [0] = {
                    mult = 20
                },
                [1] = {
                    chips = 50
                },
                [2] = {
                    x_mult = 2
                },
                [3] = {}
            },
            dollars = {0, 0, 0, 5}
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return card.ability.extra.effect[card.ability.extra.rotation % 4]
        end

        if context.Bakery_after_eval then
            G.E_MANAGER:add_event(Event {
                trigger = 'before',
                delay = 0.2,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.3)
                    card.ability.extra.rotation = card.ability.extra.rotation + 1
                    return true
                end
            })
        end
    end,
    calc_dollar_bonus = function(self, card)
        local dollars = card.ability.extra.dollars[card.ability.extra.rotation % 4 + 1]
        if dollars > 0 then
            return dollars
        end
    end,
    set_ability = function(self, joker)
        joker.ability.extra.rotation = joker.ability.extra.rotation or pseudorandom(pseudoseed("Spinner"), 0, 3)
    end
}

local raw_Card_set_sprites = Card.set_sprites
function Card:set_sprites(center, front)
    raw_Card_set_sprites(self, center, front)
    if center == j_spinner and center.unlocked and center.discovered then
        self.children.center.role.r_bond = 'Weak'
        self.children.center.role.role_type = 'Major'
        local t = self.T
        self.children.center.T = setmetatable({}, {
            __index = function(_, k)
                if k == "r" then
                    return math.rad((self.ability and self.ability.extra.rotation or 0) * 90)
                end
                return t[k]
            end,
            __newindex = function(_, k, v)
                t[k] = v
            end
        })
    end
end

sendInfoMessage("Card:set_sprites() patched. Reason: Spinner Loading", "Bakery")

local j_proxy
function Bakery_API.get_proxied_joker()
    if G.jokers and G.jokers.cards then
        local other_joker = nil
        local latest = -1
        for _, other in pairs(G.jokers.cards) do
            if other.config.center ~= j_proxy and other.ability.Bakery_purchase_index and
                other.ability.Bakery_purchase_index > latest and other.config.center.blueprint_compat then
                latest = other.ability.Bakery_purchase_index
                other_joker = other
            end
        end
        return other_joker
    end
end
j_proxy = SMODS.Joker {
    key = "Proxy",
    name = "Proxy",
    atlas = 'Bakery',
    pos = {
        x = 0,
        y = 1
    },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, card)
        local other_joker = Bakery_API.get_proxied_joker()

        return {
            vars = {other_joker and (localize {
                type = 'name_text',
                set = other_joker.config.center.set,
                key = other_joker.config.center.key
            }) or localize('k_none')}
        }
    end,
    locked_loc_vars = function(self, card)
        return {
            vars = {G.P_CENTERS['j_blueprint'].discovered and localize {
                type = 'name_text',
                key = 'j_blueprint',
                set = "Joker"
            } or localize('k_unknown'), G.P_CENTERS['j_brainstorm'].discovered and localize {
                type = 'name_text',
                key = 'j_brainstorm',
                set = "Joker"
            } or localize('k_unknown')}
        }
    end,
    check_for_unlock = function(self, args)
        if not G.jokers or not G.jokers.cards then
            return false
        end
        local print = false
        local storm = false
        for _, other in pairs(G.jokers.cards) do
            if other.config.center.key == 'j_blueprint' then
                print = true
            end
            if other.config.center.key == 'j_brainstorm' then
                storm = true
            end
        end
        return print and storm
    end,
    calculate = function(self, card, context)
        local other_joker = Bakery_API.get_proxied_joker()
        if other_joker and other_joker ~= self and not context.no_blueprint then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or self
            if context.blueprint > #G.jokers.cards + 1 then
                return
            end
            local other_joker_ret = other_joker:calculate_joker(context)
            context.blueprint = nil
            local eff_card = context.blueprint_card or self
            context.blueprint_card = nil
            if other_joker_ret then
                other_joker_ret.card = eff_card
                other_joker_ret.colour = G.C.BLUE
                return other_joker_ret
            end
        end
    end
}

SMODS.Joker {
    key = "StickerSheet",
    name = "Sticker Sheet",
    atlas = 'Bakery',
    pos = {
        x = 1,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            x_mult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.x_mult}
        }
    end,
    check_for_unlock = function(self, args)
        if not G.jokers or not G.jokers.cards then
            return false
        end
        for _, other in pairs(G.jokers.cards) do
            if other.ability.eternal and other.ability.rental then
                return true
            end
        end
        return false
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            local mod_sticker = false
            for k, v in ipairs(SMODS.Sticker.obj_buffer) do
                if context.other_joker.ability[v] then
                    mod_sticker = true
                    break
                end
            end
            if mod_sticker or context.other_joker.ability.eternal or context.other_joker.ability.rental or
                context.other_joker.ability.perishable or context.other_joker.pinned then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = {card.ability.extra.x_mult}
                    },
                    Xmult_mod = card.ability.extra.x_mult
                }
            end
        end
    end,
    in_pool = function(self, args)
        return G.GAME.stake >= 4
    end
}

local function to_number(num) -- This shouldn't be necessary, but Talisman's __lt isn't working against numbers for whatever reason
    if type(num) == "table" then
        return num:to_number()
    end
    return num
end
SMODS.Joker {
    key = "PlayingCard",
    name = "PlayingCard",
    atlas = 'Bakery',
    pos = {
        x = 2,
        y = 1
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            unlock_level = 20
        }
    },
    locked_loc_vars = function(self, card)
        return {
            vars = {self.config.extra.unlock_level}
        }
    end,
    check_for_unlock = function(self, args)
        return G.GAME.hands["High Card"].level >= self.config.extra.unlock_level
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = to_number(G.GAME.hands["High Card"].mult),
                chips = to_number(G.GAME.hands["High Card"].chips)
            }
        end
    end
}
SMODS.Joker {
    key = "PlayingCard11",
    name = "PlayingCard11",
    atlas = 'Bakery',
    pos = {
        x = 3,
        y = 1
    },
    rarity = 1,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            unlock_level = 20
        }
    },
    locked_loc_vars = function(self, card)
        return {
            vars = {self.config.extra.unlock_level}
        }
    end,
    check_for_unlock = function(self, args)
        return G.GAME.hands["Pair"].level >= self.config.extra.unlock_level
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = to_number(G.GAME.hands["Pair"].mult),
                chips = to_number(G.GAME.hands["Pair"].chips)
            }
        end
    end
}

local parity = {
    ["Ace"] = "odd",
    ["2"] = "even",
    ["3"] = "odd",
    ["4"] = "even",
    ["5"] = "odd",
    ["6"] = "even",
    ["7"] = "odd",
    ["8"] = "even",
    ["9"] = "odd",
    ["10"] = "even",
    ["Jack"] = nil,
    ["Queen"] = nil,
    ["King"] = nil
}
SMODS.Joker {
    key = "EvilSteven",
    name = "EvilSteven",
    atlas = 'Bakery',
    pos = {
        x = 4,
        y = 1
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play then
            if not SMODS.has_no_rank(context.destroying_card) and parity[context.destroying_card:get_original_rank()] ==
                "even" then
                return {
                    remove = true
                }
            end
        end
    end
}
SMODS.Joker {
    key = "AwfulTodd",
    name = "AwfulTodd",
    atlas = 'Bakery',
    pos = {
        x = 5,
        y = 1
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play then
            if not SMODS.has_no_rank(context.destroying_card) and parity[context.destroying_card:get_original_rank()] ==
                "odd" then
                return {
                    remove = true
                }
            end
        end
    end
}

SMODS.Atlas {
    key = "BakeryJokerAgainstHumanity",
    path = "BakeryJokerAgainstHumanity.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = "JokerAgainstHumanity",
    name = "JokerAgainstHumanity",
    atlas = 'BakeryJokerAgainstHumanity',
    pos = {
        x = 0,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            mult = 0,
            mult_gain = 2
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult_gain, card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.before and G.GAME.hands[context.scoring_name].level == 1 and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Upgraded!',
                colour = G.C.MULT,
                card = card
            }
        end
    end,
    set_sprites = function(self, card, front)
        local c = card or {}
        c.ability = c.ability or {}
        -- The seeding is broken by visiting the collection, but whatever, it's only cosmetic
        c.ability.Bakery_x = c.ability.Bakery_x or pseudorandom(pseudoseed("JokerAgainstHumanity"), 0, 3)
        c.ability.Bakery_y = c.ability.Bakery_y or pseudorandom(pseudoseed("JokerAgainstHumanity"), 0, 3)
        if card and card.children and card.children.center and card.children.center.set_sprite_pos then
            card.children.center:set_sprite_pos({
                x = c.ability.Bakery_x,
                y = c.ability.Bakery_y
            })
        end
    end
}

Bakery_API.load('sleeve')

SMODS.Joker {
    key = "BongardProblem",
    name = "BongardProblem",
    atlas = 'Bakery',
    pos = {
        x = 1,
        y = 2
    },
    rarity = 2,
    cost = 7,
    config = {
        extra = {
            xmult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            if not SMODS.has_no_suit(context.scoring_hand[1]) and
                not SMODS.has_no_suit(context.scoring_hand[#context.scoring_hand]) and
                (SMODS.has_any_suit(context.scoring_hand[1]) or
                    SMODS.has_any_suit(context.scoring_hand[#context.scoring_hand]) or
                    not context.scoring_hand[1]:is_suit(context.scoring_hand[#context.scoring_hand].base.suit)) then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end
}

Bakery_API.usable_jokers.j_Bakery_CoinSlot = true
SMODS.Joker {
    key = "CoinSlot",
    name = "CoinSlot",
    atlas = 'Bakery',
    pos = {
        x = 2,
        y = 2
    },
    rarity = 1,
    cost = 1,
    config = {
        extra = {
            mult = 0,
            cost = 5,
            mult_gain = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult_gain, card.ability.extra.cost, card.ability.extra.mult}
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    Bakery_can_use = function(self, card)
        return card:can_sell_card() and card.ability.extra.cost <= G.GAME.dollars + (G.GAME.dollar_buffer or 0) -
                   G.GAME.bankrupt_at
    end,
    Bakery_use_joker = function(self, card)
        if not self:Bakery_can_use(card) then
            return
        end
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
        ease_dollars(-card.ability.extra.cost)
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card_eval_status_text(card, 'extra', nil, math.random(0, 100), nil, {
            mult_mod = true,
            message = localize {
                type = 'variable',
                key = 'a_mult',
                vars = {card.ability.extra.mult}
            }
        })
        G.E_MANAGER:add_event(Event({
            func = (function()
                G.GAME.dollar_buffer = G.GAME.dollar_buffer + card.ability.extra.cost
                return true
            end)
        }))
        Bakery_API.rehighlight(card)
    end,
    Bakery_use_button_text = function(self, card)
        return localize {
            type = 'variable',
            key = 'b_Bakery_deposit',
            vars = {card.ability.extra.cost}
        }
    end
}

SMODS.Joker {
    key = "Pyrite",
    name = "Pyrite",
    atlas = 'Bakery',
    pos = {
        x = 3,
        y = 2
    },
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            cards = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.cards}
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            juice_card(card)
            for i = 1, card.ability.extra.cards do
                draw_card(G.deck, G.hand, i * 100 / card.ability.extra.cards, 'up', true)
            end
        end
    end
}
