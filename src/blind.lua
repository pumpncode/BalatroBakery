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
        min = 2,
        max = 0
    },
    boss_colour = HEX('ff004b'),
    config = {
        extra = {
            scale = 10
        }
    },
    collection_loc_vars = function(self)
        return {
            vars = {localize {
                type = 'variable',
                key = 'b_Bakery_ante_times',
                vars = {self.config.extra.scale}
            }}
        }
    end,
    loc_vars = function(self)
        return {
            vars = {G.GAME.round_resets.ante * self.config.extra.scale}
        }
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return mult - (G.GAME.round_resets.ante * self.config.extra.scale), hand_chips, true
    end
}
