-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

local function equip(key)
    Balatest.q(function()
        G.FUNCS.Bakery_equip_from_shop { config = { ref_table = Card(G.Bakery_charm_area.T.x + G.Bakery_charm_area.T.w / 2, G.Bakery_charm_area.T.y, G.CARD_W, G.CARD_W,
            G.P_CARDS.empty, G.P_CENTERS[key], {
                bypass_discovery_center = true,
                bypass_discovery_ui = true
            }) } }
    end)
end

--#region Palette
Balatest.TestPlay {
    name = 'palette_normal',
    requires = {},
    category = 'charms',

    jokers = { 'j_droll' },
    execute = function()
        equip 'BakeryCharm_Bakery_Palette'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(56 * 14)
    end
}
Balatest.TestPlay {
    name = 'palette_weird',
    requires = {},
    category = 'charms',

    jokers = { 'j_droll' },
    execute = function()
        equip 'BakeryCharm_Bakery_Palette'
        Balatest.play_hand { '2S', '3C', '4H', '5D', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(56 * 14)
    end
}
Balatest.TestPlay {
    name = 'palette_unequipped',
    requires = {},
    category = 'charms',

    jokers = { 'j_droll' },
    execute = function()
        equip 'BakeryCharm_Bakery_Palette'
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.play_hand { '2S', '3C', '4H', '5D', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
--#endregion

--#region Anaglyph Lens
Balatest.TestPlay {
    name = 'anaglyph_lens_one',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 1)
        Balatest.assert(hand_name == 'Pair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_stone',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S', e = 'm_stone' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 1)
        Balatest.assert(hand_name == 'High Card')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_four',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Five of a Kind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_four_plus_one',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D', '6S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Five of a Kind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_five',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'H' }, { r = '2', s = 'C' }, { r = '2', s = 'D' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D', '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_SixOfAKind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'C' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one_alt',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one_alt2',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'C', e = 'm_stone' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4) -- Stone happens later
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_five',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushSix')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_three_pair',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'C' }, { r = '4', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4C', '4D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_ThreePair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_three_pair',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'S' }, { r = '4', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4S', '4S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushThreePair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_three_pair_alt',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'S' }, { r = '4', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4S', '4D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_two_triplets',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'D' }, { r = '9', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2D', '9D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_TwoTriplets')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_two_triplets',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2s', '9D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushTriplets')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_mansion',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushMansion')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush House')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house_plus_one',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '3', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '3D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush House')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house_plus_one_alt',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '3', s = 'D', e = 'm_stone' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '3D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4) -- Stone happens later
        Balatest.assert(hand_name == 'Flush House')
    end
}
--#endregion

--#region Pedigree
Balatest.TestPlay {
    name = 'pedigree_normal',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2C', '2D', '3S', '3D' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Full House')
    end
}
Balatest.TestPlay {
    name = 'pedigree_weird',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '3S', '4S', '7C', 'QC' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Full House')
    end
}
Balatest.TestPlay {
    name = 'pedigree_stuffed',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'C' }, { r = '8', s = 'C' }, { r = '8', s = 'C' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2C', '8C', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StuffedHouse')
    end
}
Balatest.TestPlay {
    name = 'pedigree_stuffed_house',
    requires = {},
    category = 'charms',

    deck = { cards = { { r = '2', s = 'S', e = 'm_wild' }, { r = '2', s = 'S', e = 'm_wild' }, { r = '2', s = 'C' }, { r = '8', s = 'C' }, { r = '8', s = 'C' } } },
    execute = function()
        equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2C', '8C', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StuffedFlush')
    end
}
--#endregion

--#region Epitaph
Balatest.TestPlay {
    name = 'epitaph_one',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Epitaph'
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(16)
    end
}
Balatest.TestPlay {
    name = 'epitaph_four',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Epitaph'
        Balatest.play_hand { '2S', '3C', '4D', '5H', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12 * 16)
    end
}
Balatest.TestPlay {
    name = 'epitaph_unequipped',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Epitaph'
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.play_hand { '2S', '3C', '4D', '5H', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
--#endregion

--#region Rune
Balatest.TestPlay {
    name = 'rune_can_discard_zero',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Rune'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button == 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'rune_cant_discard_zero',
    requires = {},
    category = 'charms',

    discards = 0,
    execute = function()
        equip 'BakeryCharm_Bakery_Rune'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button ~= 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'rune_discard_zero',
    requires = {},
    category = 'charms',

    hand_size = 8,
    execute = function()
        equip 'BakeryCharm_Bakery_Rune'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 10)
    end
}
Balatest.TestPlay {
    name = 'rune_discard_zero_grat',
    requires = {},
    category = 'charms',

    jokers = { 'j_delayed_grat' },
    dollars = 8,
    hand_size = 8,
    execute = function()
        equip 'BakeryCharm_Bakery_Rune'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
--#endregion

--#region Obsession
Balatest.TestPlay {
    name = 'obsession_can_discard_zero',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button == 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'obsession_cant_discard_zero',
    requires = {},
    category = 'charms',

    discards = 0,
    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button ~= 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'obsession_discard_zero',
    requires = {},
    category = 'charms',

    dollars = 8,
    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 4)
    end
}
Balatest.TestPlay {
    name = 'obsession_discard_zero_grat',
    requires = {},
    category = 'charms',

    jokers = { 'j_delayed_grat' },
    dollars = 8,
    hand_size = 8,
    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 4)
    end
}
--#endregion

--#region Introversion
Balatest.TestPlay {
    name = 'introversion_equip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Introversion'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.joker_rate, 0)
    end
}
Balatest.TestPlay {
    name = 'introversion_unequip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Introversion'
        equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.joker_rate, 20)
    end
}
--#endregion

--#region Extroversion
Balatest.TestPlay {
    name = 'extroversion_equip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Extroversion'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.planet_rate, 0)
        Balatest.assert_eq(G.GAME.tarot_rate, 0)
    end
}
Balatest.TestPlay {
    name = 'extroversion_unequip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Extroversion'
        equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.planet_rate, 4)
        Balatest.assert_eq(G.GAME.tarot_rate, 4)
    end
}
--#endregion

--#region Coin
Balatest.TestPlay {
    name = 'coin_interest',
    requires = {},
    category = 'charms',

    dollars = 10,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_maxed',
    requires = {},
    category = 'charms',

    dollars = 38,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 35)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_moon',
    requires = {},
    category = 'charms',

    jokers = { 'j_to_the_moon' },
    dollars = 18,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 20)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_seed_money',
    requires = {},
    category = 'charms',

    vouchers = { 'v_seed_money' },
    dollars = 28,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 30)
    end
}
--#endregion

--#region Void
Balatest.TestPlay {
    name = 'void_equip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Void'
    end,
    assert = function()
        Balatest.assert_eq(G.P_CENTERS.e_negative:get_weight(), 24)
    end
}
Balatest.TestPlay {
    name = 'void_unequip',
    requires = {},
    category = 'charms',

    execute = function()
        equip 'BakeryCharm_Bakery_Void'
        equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.P_CENTERS.e_negative:get_weight(), 3)
    end
}
--#endregion
