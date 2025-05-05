-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'retrigger_tag',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_RetriggerTag'
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'retrigger_tag_shop',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.skip_blind 'tag_Bakery_RetriggerTag'
        Balatest.hook_raw(Bakery_API, 'retrigger_jokers', Bakery_API.sized_table { j_mime = true })
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_eq(G.shop_jokers.cards[1].cost, 0)
        Balatest.assert(G.shop_jokers.cards[1].config.center.key == 'j_mime')
    end
}
Balatest.TestPlay {
    name = 'retrigger_tag_exhausted',
    requires = {},
    category = 'tags',

    jokers = { 'j_mime' },
    no_auto_start = true,
    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.skip_blind 'tag_Bakery_RetriggerTag'
        Balatest.hook_raw(Bakery_API, 'retrigger_jokers', Bakery_API.sized_table { j_mime = true })
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_neq(G.shop_jokers.cards[1].cost, 0)
    end
}

Balatest.TestPlay {
    name = 'chocolate_tag_once',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_ChocolateTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(32 * 6)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.chips, 20)
        Balatest.assert_eq(G.GAME.tags[1].ability.mult, 4)
    end
}
Balatest.TestPlay {
    name = 'chocolate_tag_four_times',
    requires = {},
    category = 'tags',

    blind = 'bl_big',
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_ChocolateTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '2C' }
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        Balatest.assert_chips(466)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.chips, 5)
        Balatest.assert_eq(G.GAME.tags[1].ability.mult, 1)
    end
}
Balatest.TestPlay {
    name = 'chocolate_tag_five_times',
    requires = {},
    category = 'tags',

    blind = 'bl_big',
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_ChocolateTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '2C' }
        Balatest.play_hand { '2D' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(24)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}

Balatest.TestPlay {
    name = 'poly_tag_once',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PolyTag'
        Balatest.start_round()
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'poly_tag_multiple',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PolyTag'
        Balatest.start_round()
        Balatest.play_hand { '3S' }
        Balatest.play_hand { '3H' }
        Balatest.play_hand { '3C' }
        Balatest.play_hand { '3D' }
    end,
    assert = function()
        Balatest.assert_chips(48)
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'poly_tag_zero',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PolyTag'
        Balatest.start_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}

Balatest.TestPlay {
    name = 'penny_tag_one_card',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PennyTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 1)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 4)
    end
}
Balatest.TestPlay {
    name = 'penny_tag_two_cards',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PennyTag'
        Balatest.start_round()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 2)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 4)
    end
}
Balatest.TestPlay {
    name = 'penny_tag_two_cards_high',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PennyTag'
        Balatest.start_round()
        Balatest.play_hand { '2S', '3H' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 1)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 4)
    end
}
Balatest.TestPlay {
    name = 'penny_tag_one_card_red_seal',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    deck = { cards = { { r = '2', s = 'S', g = 'Red' }, { r = '3', s = 'S' } } },
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PennyTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 2)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 4)
    end
}
Balatest.TestPlay {
    name = 'penny_tag_five_times',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_PennyTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '2C' }
        Balatest.play_hand { '2D' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 5)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}

Balatest.TestPlay {
    name = 'blank_tag_inert',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.start_round()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'blank_tag_in_pool_default',
    requires = {},
    category = 'tags',

    execute = function() end,
    assert = function()
        Balatest.assert(G.P_TAGS.tag_Bakery_BlankTag:in_pool())
    end
}
Balatest.TestPlay {
    name = 'blank_tag_in_pool_dup',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
    end,
    assert = function()
        Balatest.assert(not G.P_TAGS.tag_Bakery_BlankTag:in_pool())
    end
}

Balatest.TestPlay {
    name = 'anti_tag_in_pool_default',
    requires = {},
    category = 'tags',

    execute = function() end,
    assert = function()
        Balatest.assert(not G.P_TAGS.tag_Bakery_AntiTag:in_pool())
    end
}
Balatest.TestPlay {
    name = 'anti_tag_in_pool_dup',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
    end,
    assert = function()
        Balatest.assert(G.P_TAGS.tag_Bakery_AntiTag:in_pool())
    end
}
Balatest.TestPlay {
    name = 'anti_tag_used',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.skip_blind 'tag_Bakery_AntiTag'
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_eq(G.jokers.config.card_limit, 6)
    end
}
Balatest.TestPlay {
    name = 'anti_tag_used_two_blank',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.skip_blind 'tag_Bakery_AntiTag'
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert(G.GAME.tags[1].key == 'tag_Bakery_BlankTag')
        Balatest.assert_eq(G.jokers.config.card_limit, 6)
    end
}
Balatest.TestPlay {
    name = 'anti_tag_duped_blank',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.skip_blind 'tag_double'
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.skip_blind 'tag_Bakery_AntiTag'
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_eq(G.jokers.config.card_limit, 7)
    end
}

Balatest.TestPlay {
    name = 'equip_tag',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_CharmTag'
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_eq(#G.shop_vouchers.cards, 4)
        Balatest.assert(G.shop_vouchers.cards[1].config.center.set == 'BakeryCharm')
        Balatest.assert(G.shop_vouchers.cards[2].config.center.set == 'Voucher')
        Balatest.assert(G.shop_vouchers.cards[3].config.center.set == 'BakeryCharm')
        Balatest.assert(G.shop_vouchers.cards[4].config.center.set == 'BakeryCharm')
    end
}

Balatest.TestPlay {
    name = 'down_tag_small',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert(not G.GAME.blind.disabled)
    end
}
Balatest.TestPlay {
    name = 'down_tag_big',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    blind = 'bl_big',
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert(not G.GAME.blind.disabled)
    end
}
Balatest.TestPlay {
    name = 'down_tag_serpent',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    blind = 'bl_serpent',
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert(G.GAME.blind.disabled)
    end
}
Balatest.TestPlay {
    name = 'down_tag_vessel',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    blind = 'bl_final_vessel',
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert(G.GAME.blind.disabled)
    end
}
Balatest.TestPlay {
    name = 'down_tag_two',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    blind = 'bl_final_vessel',
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert(G.GAME.blind.disabled)
    end
}

Balatest.TestPlay {
    name = 'up_tag_once',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_UpTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(9)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 2)
    end
}
Balatest.TestPlay {
    name = 'up_tag_twice',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_UpTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(18)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 1)
    end
}
Balatest.TestPlay {
    name = 'up_tag_thrice',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_UpTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(27)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'up_tag_wrathful',
    requires = {},
    category = 'tags',

    jokers = { 'j_wrathful_joker' },
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_UpTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(9 * 7)
        Balatest.assert_eq(#G.GAME.tags, 1)
        Balatest.assert_eq(G.GAME.tags[1].ability.hands, 2)
    end
}

local tags_3 = {
    { "alert",   "Alert",   "m_glass" },
    { "gold",    "Gold",    "m_gold" },
    { "battery", "Battery", "m_steel" },
    { "rock",    "Rock",    "m_stone" },
    { "equal",   "Equal",   "m_wild" },
}
local tags_5 = {
    { "roulette", "Roulette", "m_lucky" },
    { "blue",     "Blue",     "m_bonus" },
    { "red",      "Red",      "m_mult" },
}

for _, tag in ipairs(tags_3) do
    Balatest.TestPlay {
        name = tag[1] .. '_tag_full',
        requires = {},
        category = 'tags',

        dollars = 0,
        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
        end,
        assert = function()
            Balatest.assert_chips(224)
            Balatest.assert_eq(G.GAME.dollars, 0)
            Balatest.assert_eq(#G.GAME.tags, 0)
            Balatest.assert_eq(#G.discard.cards, 5)
            local count = 0
            for _, card in pairs(G.discard.cards) do
                if card.config.center.key == tag[3] then count = count + 1 end
            end
            Balatest.assert_eq(count, 3)
        end
    }
    Balatest.TestPlay {
        name = tag[1] .. '_tag_sub',
        requires = {},
        category = 'tags',

        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2S' }
        end,
        assert = function()
            Balatest.assert_chips(7)
            Balatest.assert_eq(#G.GAME.tags, 1)
            Balatest.assert_eq(G.GAME.tags[1].ability.amount, 2)
            Balatest.assert_eq(#G.discard.cards, 1)
            Balatest.assert(G.discard.cards[1].config.center.key == tag[3])
        end
    }
    Balatest.TestPlay {
        name = tag[1] .. '_tag_stack',
        requires = {},
        category = 'tags',

        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
        end,
        assert = function()
            Balatest.assert_chips(224)
            Balatest.assert_eq(#G.GAME.tags, 1)
            Balatest.assert_eq(G.GAME.tags[1].ability.amount, 1)
            Balatest.assert_eq(#G.discard.cards, 5)
            Balatest.assert(G.discard.cards[1].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[2].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[3].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[4].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[5].config.center.key == tag[3])
        end
    }
end
for _, tag in ipairs(tags_5) do
    Balatest.TestPlay {
        name = tag[1] .. '_tag_full',
        requires = {},
        category = 'tags',

        dollars = 0,
        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
        end,
        assert = function()
            Balatest.assert_chips(224)
            Balatest.assert_eq(G.GAME.dollars, 0)
            Balatest.assert_eq(#G.GAME.tags, 0)
            Balatest.assert_eq(#G.discard.cards, 5)
            Balatest.assert(G.discard.cards[1].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[2].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[3].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[4].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[5].config.center.key == tag[3])
        end
    }
    Balatest.TestPlay {
        name = tag[1] .. '_tag_sub',
        requires = {},
        category = 'tags',

        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2S' }
        end,
        assert = function()
            Balatest.assert_chips(7)
            Balatest.assert_eq(#G.GAME.tags, 1)
            Balatest.assert_eq(G.GAME.tags[1].ability.amount, 4)
            Balatest.assert_eq(#G.discard.cards, 1)
            Balatest.assert(G.discard.cards[1].config.center.key == tag[3])
        end
    }
    Balatest.TestPlay {
        name = tag[1] .. '_tag_stack',
        requires = {},
        category = 'tags',

        no_auto_start = true,
        execute = function()
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.skip_blind('tag_Bakery_' .. tag[2] .. 'Tag')
            Balatest.start_round()
            Balatest.play_hand { '2C' }
            Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
        end,
        assert = function()
            Balatest.assert_chips(231)
            Balatest.assert_eq(#G.GAME.tags, 1)
            Balatest.assert_eq(G.GAME.tags[1].ability.amount, 4)
            Balatest.assert_eq(#G.discard.cards, 6)
            Balatest.assert(G.discard.cards[1].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[2].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[3].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[4].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[5].config.center.key == tag[3])
            Balatest.assert(G.discard.cards[6].config.center.key == tag[3])
        end
    }
end

Balatest.TestPlay {
    name = 'strange_tag_play_min_shot',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_StrangeTag'
        Balatest.start_round()
        local val = 0
        Balatest.hook(_G, 'pseudorandom', function()
            val = 1 - val
            return val
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(77)
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'strange_tag_play_max_shot',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_StrangeTag'
        Balatest.start_round()
        Balatest.hook(_G, 'pseudorandom', function()
            return 1
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(217)
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}
Balatest.TestPlay {
    name = 'strange_tag_gone',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_StrangeTag'
        Balatest.start_round()
        Balatest.hook(_G, 'pseudorandom', function()
            return 0
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(77)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}

Balatest.TestPlay {
    name = 'top_tag_52',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_TopTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 52)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'top_tag_0',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    deck = { cards = {} },
    execute = function()
        Balatest.skip_blind 'tag_Bakery_TopTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'top_tag_1',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    deck = { cards = { { r = '2', s = 'S' } } },
    execute = function()
        Balatest.skip_blind 'tag_Bakery_TopTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 1)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}

Balatest.TestPlay {
    name = 'bottom_tag_empty',
    requires = {},
    category = 'tags',

    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BottomTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 50)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'bottom_tag_full',
    requires = {},
    category = 'tags',

    jokers = { 'j_joker', 'j_joker', 'j_joker', 'j_joker', 'j_joker' },
    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BottomTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'bottom_tag_one',
    requires = {},
    category = 'tags',

    jokers = { 'j_joker' },
    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BottomTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 40)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
Balatest.TestPlay {
    name = 'bottom_tag_black',
    requires = {},
    category = 'tags',

    back = 'Black Deck',
    no_auto_start = true,
    dollars = 0,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BottomTag'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 60)
        Balatest.assert_eq(#G.GAME.tags, 0)
    end
}
