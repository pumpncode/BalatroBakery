-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

--#region Scribe
Balatest.TestPlay {
    name = 'scribe_can_use_null',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function() end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_playing',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_joker',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_two_playing',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        Balatest.highlight { '2S', '3S' }
    end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
-- Balatest.TestPlay {
--     name = 'scribe_can_use_two_joker',
--     requires = {},
--     category = 'consumables',

--     jokers = { 'j_joker', 'j_joker' },
--     consumeables = { 'c_Bakery_Scribe' },
--     execute = function()
--         G.jokers:add_to_highlighted(G.jokers.cards[1], true)
--         G.jokers:add_to_highlighted(G.jokers.cards[2], true)
--     end,
--     assert = function()
--         Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
--     end
-- }
Balatest.TestPlay {
    name = 'scribe_can_use_playing_joker',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker', 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_joker_full',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker', 'j_joker', 'j_joker', 'j_joker', 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
    end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_use_playing',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker', 'j_joker', 'j_joker', 'j_joker', 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    deck = { cards = { { r = '2', s = 'S' } } },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 2)
        Balatest.assert(G.hand.cards[2].edition.key == 'e_Bakery_Carbon')
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_playing_edition',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker', 'j_joker', 'j_joker', 'j_joker', 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    deck = { cards = { { r = '2', s = 'S', d = 'foil' } } },
    execute = function()
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_use_playing_edition',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker', 'j_joker', 'j_joker', 'j_joker', 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    deck = { cards = { { r = '2', s = 'S', d = 'foil' } } },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 2)
        Balatest.assert(G.hand.cards[1].edition.key ~= 'e_Bakery_Carbon')
        Balatest.assert(G.hand.cards[2].edition.key == 'e_Bakery_Carbon')
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_joker_edition',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers.cards[1]:set_edition('e_foil', true)
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.q(function() end) -- Wait a frame for the edition to be applied? IDK why this is necessary tbh
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_use_joker',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2)
        Balatest.assert(G.jokers.cards[1].edition == nil)
        Balatest.assert(G.jokers.cards[2].edition.key == 'e_Bakery_Carbon')
    end
}
Balatest.TestPlay {
    name = 'scribe_use_joker_edition',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers.cards[1]:set_edition('e_foil', true)
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2)
        Balatest.assert(G.jokers.cards[1].edition.key ~= 'e_Bakery_Carbon')
        Balatest.assert(G.jokers.cards[2].edition.key == 'e_Bakery_Carbon')
    end
}
Balatest.TestPlay {
    name = 'scribe_can_use_joker_eternal',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers.cards[1]:set_eternal(true)
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'scribe_use_joker_eternal',
    requires = {},
    category = 'consumables',

    jokers = { 'j_joker' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers.cards[1]:set_eternal(true)
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2)
        Balatest.assert(G.jokers.cards[1].ability.eternal)
        Balatest.assert(not G.jokers.cards[2].ability.eternal)
    end
}
Balatest.TestPlay {
    name = 'scribe_hologram_joker',
    requires = {},
    category = 'consumables',

    jokers = { 'j_hologram' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        G.jokers:add_to_highlighted(G.jokers.cards[1], true)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.x_mult, 1)
    end
}
Balatest.TestPlay {
    name = 'scribe_hologram_card',
    requires = {},
    category = 'consumables',

    jokers = { 'j_hologram' },
    consumeables = { 'c_Bakery_Scribe' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.x_mult, 1.25)
    end
}
--#endregion Scribe

--#region Time Machine
Balatest.TestPlay {
    name = 'time_machine_can_use_null',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    execute = function() end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'time_machine_can_use_one',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    execute = function()
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'time_machine_can_use_two',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    execute = function()
        Balatest.highlight { '2S', '3S' }
    end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'time_machine_use',
    requires = { 'time_machine_can_use_one' },
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    deck = { cards = { { r = '2', s = 'S' } } },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
        Balatest.assert(G.hand.cards[1].config.center.key == 'm_Bakery_TimeWalk')
    end
}
Balatest.TestPlay {
    name = 'time_machine_can_use_enhanced',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    deck = { cards = { { r = '2', s = 'S', e = 'm_wild' } } },
    execute = function()
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'time_machine_use_enhanced',
    requires = { 'time_machine_can_use_enhanced' },
    category = 'consumables',

    consumeables = { 'c_Bakery_TimeMachine' },
    deck = { cards = { { r = '2', s = 'S', e = 'm_wild' } } },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
        Balatest.assert(G.hand.cards[1].config.center.key == 'm_Bakery_TimeWalk')
    end
}
--#endregion Time Machine

--#region Astrology
Balatest.TestPlay {
    name = 'astrology_can_use_null',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_Astrology' },
    execute = function() end,
    assert = function()
        Balatest.assert(not G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'astrology_can_use_one',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_Astrology' },
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'astrology_use_one',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_Astrology' },
    dollars = 0,
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 10)
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1)
    end
}
Balatest.TestPlay {
    name = 'astrology_use_two',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_Astrology' },
    dollars = 0,
    execute = function()
        level_up_hand(nil, 'High Card', true, 2)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 20)
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1)
    end
}
Balatest.TestPlay {
    name = 'astrology_use_two_split',
    requires = {},
    category = 'consumables',

    consumeables = { 'c_Bakery_Astrology' },
    dollars = 0,
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        level_up_hand(nil, 'Pair', true, 1)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 20)
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1)
        Balatest.assert_eq(G.GAME.hands['Pair'].level, 1)
    end
}
--#endregion Astrology
