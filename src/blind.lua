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
    if G.GAME.blind.config.blind.key == "bl_Bakery_He" and G.play.cards[1] then
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
