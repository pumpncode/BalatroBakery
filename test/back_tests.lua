-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'violet',
    requires = {},
    category = 'backs',

    back = 'Violet',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}

Balatest.TestPlay {
    name = 'house_yes',
    requires = {},
    category = 'backs',

    back = 'House',
    seed = 'House',
    execute = function()
        G.GAME.probabilities.normal = 1024
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.discard.cards, 1)
        Balatest.assert(G.discard.cards[1].base.suit == 'Diamonds')
        Balatest.assert(G.discard.cards[1].base.value == '7')
    end
}
Balatest.TestPlay {
    name = 'house_no',
    requires = {},
    category = 'backs',

    back = 'House',
    seed = 'House',
    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.discard.cards, 1)
        Balatest.assert(G.discard.cards[1].base.suit == 'Spades')
        Balatest.assert(G.discard.cards[1].base.value == '2')
    end
}

Balatest.TestPlay {
    name = 'credit_cash_out',
    requires = {},
    category = 'backs',

    back = 'Credit',
    custom_rules = {
        { id = 'no_reward',           value = false },
        { id = 'no_interest',         value = false },
        { id = 'no_extra_hand_money', value = false },
        { id = 'money_per_discard',   value = 1 },
    },
    hands = 1,
    discards = 1,
    money = 0,
    jokers = { 'j_golden' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
Balatest.TestPlay {
    name = 'credit_rental_gold',
    requires = {},
    category = 'backs',

    back = 'Credit',
    money = 0,
    jokers = { 'j_joker' },
    deck = { cards = { { s = 'S', r = '2', e = 'm_gold' } } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, -3)
    end
}
--Todo: Credit purchase something
