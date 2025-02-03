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

SMODS.Atlas {
    key = "BakeryBack",
    path = "BakeryBack.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BakeryBlinds",
    path = "BakeryBlinds.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21
}

SMODS.Atlas {
    key = "BakerySleeves",
    path = "BakerySleeves.png",
    px = 73,
    py = 95
}

Bakery_API.retrigger_jokers = Bakery_API.sized_table {
    j_mime = true,
    j_dusk = true,
    j_hack = true,
    j_selzer = true,
    j_sock_and_buskin = true,
    j_hanging_chad = true
}

SMODS.Tag {
    key = "RetriggerTag",
    atlas = 'BakeryTags',
    pos = {
        x = 0,
        y = 0
    },
    min_ante = 4,
    config = {
        type = 'store_joker_create'
    },
    loc_vars = function(self, info_queue, card)
        for k in pairs(Bakery_API.retrigger_jokers) do
            if G.P_CENTERS[k] ~= nil then
                info_queue[#info_queue + 1] = G.P_CENTERS[k]
            end
        end
    end,
    apply = function(self, tag, context)
        if not tag.triggered and tag.config.type == context.type then
            tag.triggered = true

            local in_posession = {0}
            for k, v in ipairs(G.jokers.cards) do
                if Bakery_API.retrigger_jokers[v.config.center.rarity] and not in_posession[v.config.center.key] then
                    in_posession[1] = in_posession[1] + 1
                    in_posession[v.config.center.key] = true
                end
            end

            if Bakery_API.retrigger_jokers.Length > in_posession[1] then
                local j, k = pseudorandom_element(Bakery_API.retrigger_jokers, pseudoseed('Retrigger Tag'))
                local card = create_card('Joker', context.area, nil, 2, nil, nil, k, 'Retrigger Tag')
                create_shop_card_ui(card, 'Joker', context.area)
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

SMODS.Tag {
    key = "ChocolateTag",
    atlas = 'BakeryTags',
    pos = {
        x = 1,
        y = 0
    },
    min_ante = 0,
    config = {
        type = 'play_hand_early',
        chips = 25,
        mult = 5,
        d_chips = 5,
        d_mult = 1
    },
    loc_vars = function(self, info_queue, tag)
        tag.ability.chips = tag.ability.chips or self.config.chips
        tag.ability.mult = tag.ability.mult or self.config.mult
        return {
            vars = {tag.ability.chips, tag.ability.mult, self.config.d_chips, self.config.d_mult}
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered and self.config.type == context.type then
            tag.ability.chips = tag.ability.chips or self.config.chips
            tag.ability.mult = tag.ability.mult or self.config.mult
            local ret = {
                chips = tag.ability.chips,
                mult = tag.ability.mult
            }
            tag.ability.chips = math.max(tag.ability.chips - self.config.d_chips, 0)
            tag.ability.mult = math.max(tag.ability.mult - self.config.d_mult, 0)
            if tag.ability.chips == 0 and tag.ability.mult == 0 then
                ret.after = function()
                    tag:yep('X', G.C.RED, function()
                        return true
                    end)
                end
            end
            return ret
        end
    end
}

SMODS.Tag {
    key = "PolyTag",
    atlas = 'BakeryTags',
    pos = {
        x = 2,
        y = 0
    },
    min_ante = 0,
    config = {
        type = 'play_hand_late',
        x_mult = 3
    },
    loc_vars = function(self, info_queue, tag)
        return {
            vars = {self.config.x_mult}
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered and self.config.type == context.type then
            return {
                x_mult = self.config.x_mult
            }
        end
        if not tag.triggered and context.type == 'eval' then
            tag.triggered = true
            tag:yep('X', G.C.RED, function()
                return true
            end)
        end
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Tag.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

        if card then
            -- card.tag_sprite:define_draw_steps({{
            --     shader = 'dissolve',
            --     shadow_height = 0.05
            -- }, {
            --     shader = 'dissolve'
            -- }, {
            --     shader = 'polychrome'
            -- }})
            card.tag_sprite:draw_shader('polychrome', nil, nil)
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

local b_violet = SMODS.Back {
    key = "Violet",
    name = "Violet",
    config = {
        extra = {
            x_mult = 2
        }
    },
    atlas = "BakeryBack",
    pos = {
        x = 0,
        y = 0
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return Bakery_API.defeated_blinds['bl_final_vessel'] > 0
    end,
    locked_loc_vars = function(self, args)
        if G.P_BLINDS['bl_final_vessel'].discovered then
            return {
                vars = {localize {
                    type = 'name_text',
                    key = 'bl_final_vessel',
                    set = "Blind"
                }}
            }
        end
        return {
            vars = {localize('k_unknown')}
        }
    end,
    loc_vars = function(self, info_queue, back)
        return {
            vars = {self.config.extra.x_mult}
        }
    end,
    calculate = function(self, back, args)
        if args.context == 'final_scoring_step' then
            args.mult = args.mult * self.config.extra.x_mult

            local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims

            update_hand_text({
                delay = 0
            }, {
                mult = args.mult
            })
            if not skip then
                G.E_MANAGER:add_event(Event {
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_xmult',
                                vars = {self.config.extra.x_mult}
                            },
                            scale = 1.4,
                            hold = 2,
                            offset = {
                                x = 0,
                                y = -2.7
                            },
                            major = G.play
                        }
                        play_sound('multhit2', 0.845 + 0.04 * math.random(), 0.7)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                })
            end

            return args.chips, args.mult
        end
    end
}

local b_house = SMODS.Back {
    key = "House",
    name = "House",
    config = {
        extra = {
            odds_bottom = 4
        }
    },
    atlas = "BakeryBack",
    pos = {
        x = 1,
        y = 0
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return get_deck_win_stake('b_erratic') > 0
    end,
    locked_loc_vars = function(self, back)
        if G.P_CENTERS['b_erratic'].discovered then
            return {
                vars = {localize {
                    type = 'name_text',
                    key = 'b_erratic',
                    set = "Back"
                }}
            }
        end
        return {
            vars = {localize('k_unknown')}
        }
    end,
    loc_vars = function(self)
        return {
            vars = {(G.GAME and G.GAME.probabilities.normal or 1) *
                (G.GAME.selected_sleeve == 'sleeve_Bakery_House' and G.GAME.selected_back_key == 'b_Bakery_House' and 2 or
                    1), self.config.extra.odds_bottom}
        }
    end,
    calculate = function(self, back, args)
        if args.context == 'final_scoring_step' then
            local anim = {}

            local double = G.GAME.selected_sleeve == 'sleeve_Bakery_House' and G.GAME.selected_back_key ==
                               'b_Bakery_House'

            for i = 1, #G.play.cards do
                local choice = pseudorandom(pseudoseed("HouseDeck"), 0, self.config.extra.odds_bottom)
                if double then
                    choice = choice / 2
                end
                if choice <= (G.GAME and G.GAME.probabilities.normal or 1) then
                    table.insert(anim, G.play.cards[i])
                end
            end

            if #anim == 0 then
                return
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    return true
                end
            }))
            for i = 1, #anim do
                local percent = 1.15 - (i - 0.999) / (#anim - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        anim[i]:flip();
                        play_sound('card1', percent);
                        anim[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            delay(0.2)

            for i = 1, #anim do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local card = anim[i]
                        local rank = pseudorandom_element(SMODS.Ranks, pseudoseed("HouseDeck")).card_key
                        local suit = pseudorandom_element(SMODS.Suits, pseudoseed("HouseDeck")).card_key
                        card:set_base(G.P_CARDS[suit .. "_" .. rank])
                        if double then
                            if not card.edition then
                                local ed = poll_edition("HouseDeck", nil, true)
                                if ed then
                                    card:set_edition(ed)
                                end
                            end
                            if card.ability.name == G.P_CENTERS.c_base.name then
                                local en = SMODS.poll_enhancement {
                                    type_key = "HouseDeck"
                                }
                                if en then
                                    card:set_ability(G.P_CENTERS[en])
                                end
                            end
                            if not card:get_seal(true) then
                                local se = SMODS.poll_seal {
                                    type_key = "HouseDeck"
                                }
                                if se then
                                    card:set_seal(se)
                                end
                            end
                        end
                        return true
                    end
                }))
                local percent = 0.85 + (i - 0.999) / (#anim - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        anim[i]:flip();
                        play_sound('tarot2', percent, 0.6);
                        anim[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            delay(0.7)
        end
    end
}

-- Items that, with the Credit Deck, can never be better than the same item doing absolutely nothing.
-- For example, Egg is not on this list, since sell value can still matter for Swashbuckler or Ceremonial Dagger.
-- Neither is Midas Mask, since it can feed Vampire or Driver's License.
Bakery_API.econ_only_items = {'j_delayed_grat', 'j_business', 'j_faceless', 'j_cloud_9', 'j_rocket',
                              'j_reserved_parking', 'j_mail', 'j_to_the_moon', 'j_golden', 'j_ticket', 'j_rough_gem',
                              'j_satellite', 'j_Bakery_Auctioneer', 'v_seed_money', 'v_money_tree', 'c_hermit',
                              'c_temperance', 'tag_investment', 'tag_skip', 'tag_economy'}

local b_credit = SMODS.Back {
    key = "Credit",
    name = "Credit",
    config = {
        dollars = 200,
        no_interest = true
    },
    atlas = "Joker",
    prefix_config = {
        atlas = false
    },
    pos = {
        x = 5,
        y = 1
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return get_deck_win_stake('b_yellow') > 3
    end,
    locked_loc_vars = function(self, back)
        if G.P_CENTERS['b_yellow'].discovered then
            return {
                vars = {
                    localize {
                        type = 'name_text',
                        key = 'b_yellow',
                        set = "Back"
                    },
                    localize {
                        type = 'name_text',
                        set = 'Stake',
                        key = 'stake_black'
                    },
                    colours = {G.C.BLACK}
                }
            }
        end
        return {
            vars = {
                localize('k_unknown'),
                localize {
                    type = 'name_text',
                    set = 'Stake',
                    key = 'stake_black'
                },
                colours = {G.C.BLACK}
            }
        }
    end,
    loc_vars = function(self, info_queue, back)
        return {
            vars = {self.config.dollars}
        }
    end,
    apply = function(self, back)
        G.GAME.modifiers.no_blind_reward = {
            Small = true,
            Big = true,
            Boss = true
        }
        G.GAME.modifiers.no_extra_hand_money = true
        for _, k in ipairs(Bakery_API.econ_only_items) do
            G.GAME.banned_keys[k] = true
        end
    end
}

SMODS.Blind {
    key = "Aleph",
    atlas = "BakeryBlinds",
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('a9e74b'),
    set_blind = function(self)
        ease_discard(-1)
        ease_hands_played(-1)
    end,
    disable = function(self)
        ease_discard(1)
        ease_hands_played(1)
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "Violet",
        atlas = "BakerySleeves",
        pos = {
            x = 0,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_Violet",
            stake = "stake_black"
        },
        calculate = b_violet.calculate,
        config = b_violet.config,
        loc_vars = b_violet.loc_vars
    }

    CardSleeves.Sleeve {
        key = "House",
        atlas = "BakerySleeves",
        pos = {
            x = 1,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_House",
            stake = "stake_red"
        },
        config = b_house.config,
        calculate = function(self, sleeve, context)
            local key, vars
            if self.get_current_deck_key() ~= "b_Bakery_House" then
                return b_house.calculate(self, sleeve, context)
            end
        end,
        loc_vars = function(self)
            if self.get_current_deck_key() ~= "b_Bakery_House" then
                return b_house.loc_vars(self)
            end
            return {
                key = self.key .. "_alt"
            }
        end
    }

    CardSleeves.Sleeve {
        key = "Credit",
        atlas = "BakerySleeves",
        pos = {
            x = 2,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_Credit",
            stake = "stake_black"
        },
        config = {
            dollars = 200,
            alt_dollars = 100,
            no_interest = true
        },
        loc_vars = function(self, info_queue, back)
            local key = self.key
            local dollars = self.config.dollars
            if self.get_current_deck_key() == "b_Bakery_Credit" then
                key = key .. "_alt"
                dollars = dollars + self.config.alt_dollars
            end
            return {
                key = key,
                vars = {dollars}
            }
        end,
        apply = function(self)
            G.GAME.modifiers.no_interest = true
            b_credit.apply()
            G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + self.config.dollars
            if self.get_current_deck_key() == "b_Bakery_Credit" then
                G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + self.config.alt_dollars
            end
        end,
        calculate = function(self, sleeve, context)
            if self.get_current_deck_key() == "b_Bakery_Credit" and context.context == 'Bakery_after_press_play' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        for i = 1, #G.play.cards do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.play.cards[i]:juice_up();
                                    return true
                                end
                            }))
                            ease_dollars(-1)
                            delay(0.23)
                        end
                        return true
                    end
                }))
            end
        end
    }
end
