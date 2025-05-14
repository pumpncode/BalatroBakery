SMODS.Atlas {
    key = "BakeryBlinds",
    path = "BakeryBlinds.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21
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

SMODS.Blind {
    key = "Tsadi",
    atlas = "BakeryBlinds",
    pos = {
        y = 1
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('ff004b'),
    config = {
        extra = {
            scale = 5
        }
    },
    collection_loc_vars = function(self)
        return {
            vars = { localize {
                type = 'variable',
                key = 'b_Bakery_ante_times',
                vars = { self.config.extra.scale }
            } }
        }
    end,
    loc_vars = function(self)
        return {
            vars = { G.GAME.round_resets.ante * self.config.extra.scale }
        }
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return mult - (G.GAME.round_resets.ante * self.config.extra.scale), hand_chips, true
    end
}

local raw_SMODS_never_scores = SMODS.never_scores
function SMODS.never_scores(card)
    if G.GAME.blind.config.blind.key == "bl_Bakery_He" and not G.GAME.blind.disabled and G.play.cards[1] then
        local max = 1
        local max_rank = G.play.cards[1].base.nominal
        for i = 2, #G.play.cards do
            if G.play.cards[i].base.nominal > max_rank then
                max = i
                max_rank = G.play.cards[i].base.nominal
            end
        end
        if card ~= G.play.cards[max] then
            return true
        end
    end
    return raw_SMODS_never_scores(card)
end

sendInfoMessage("SMODS.never_scores() patched. Reason: The Solo Boss Blind", "Bakery")

SMODS.Blind {
    key = "He",
    atlas = "BakeryBlinds",
    pos = {
        y = 2
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('ffd78e')
}

SMODS.Blind {
    key = "Qof",
    atlas = "BakeryBlinds",
    pos = {
        y = 3
    },
    boss = {
        min = 2,
        max = 0
    },
    boss_colour = HEX('e9b4ff'),
    collection_loc_vars = function(self)
        return { vars = { localize 'b_Bakery_ante' } }
    end,
    loc_vars = function(self)
        return { vars = { G.GAME.round_resets.ante } }
    end,
    set_blind = function(self)
        local cards = {}
        for _ = 1, G.GAME.round_resets.ante do
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('bl_Bakery_Qof'))
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local card = Card(G.discard.T.x + G.discard.T.w / 2, G.discard.T.y, G.CARD_W, G.CARD_H, front,
                G.P_CENTERS.m_Bakery_Curse, { playing_card = G.playing_card })
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end
            }))
            cards[#cards + 1] = card
        end

        for i = 1, G.GAME.round_resets.ante do
            draw_card(G.play, G.deck, 90 + i, 'up', nil)
        end
        playing_card_joker_effects(cards)
    end,
    disable = function(self)
        local done = 0
        for i = 1, #G.deck.cards do
            if G.deck.cards[i].config.center.key == 'm_Bakery_Curse' then
                G.E_MANAGER:add_event(Event {
                    func = function()
                        G.deck.cards[i]:start_dissolve()
                        return true
                    end
                })
                done = done + 1
                if done >= G.GAME.round_resets.ante then
                    return
                end
            end
        end
    end
}

SMODS.Blind {
    key = "Kaf",
    atlas = "BakeryBlinds",
    pos = {
        y = 4
    },
    boss = {
        min = 2,
        max = 0
    },
    boss_colour = HEX('93a9ff'),
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return mult, 0, hand_chips ~= 0
    end
}
