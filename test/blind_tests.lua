-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'leader',
    requires = {},
    category = 'blinds',

    hands = 5,
    discards = 5,
    blind = 'bl_Bakery_Aleph',
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 4)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 4)
    end
}
Balatest.TestPlay {
    name = 'leader_chicot',
    requires = {},
    category = 'blinds',

    jokers = { 'j_chicot' },
    hands = 5,
    discards = 5,
    blind = 'bl_Bakery_Aleph',
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 5)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 5)
    end
}

Balatest.TestPlay {
    name = 'attrition',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_Tsadi',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(-28)
    end
}
Balatest.TestPlay {
    name = 'attrition_chicot',
    requires = {},
    category = 'blinds',

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Tsadi',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}

Balatest.TestPlay {
    name = 'solo_single',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'solo_double',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(32 * 3)
    end
}
Balatest.TestPlay {
    name = 'solo_straight',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '3H', '6S', '4C', '5D' }
    end,
    assert = function()
        Balatest.assert_chips(36 * 4)
    end
}
Balatest.TestPlay {
    name = 'solo_chicot',
    requires = {},
    category = 'blinds',

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(36 * 3)
    end
}

Balatest.TestPlay {
    name = 'witch',
    requires = {},
    category = 'blinds',

    hand_size = 100,
    blind = 'bl_Bakery_Qof',
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 53)
    end
}
Balatest.TestPlay {
    name = 'witch_chicot',
    requires = {},
    category = 'blinds',

    hand_size = 100,
    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Qof',
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)
    end
}

Balatest.TestPlay {
    name = 'build',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_Kaf',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(2)
    end
}
Balatest.TestPlay {
    name = 'build_chicot',
    requires = {},
    category = 'blinds',

    blind = 'bl_Bakery_Kaf',
    jokers = { 'j_chicot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
