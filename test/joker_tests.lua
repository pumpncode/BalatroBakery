--#region Tarmogoyf
Balatest.TestPlay {
    name = 'tarmogoyf_null',
    requires = {},
    category = 'tarmogoyf',

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded',
    requires = {},
    category = 'tarmogoyf',

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { '2H', '3H', '4H', '5H', '6H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 6)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded_duplicates',
    requires = {},
    category = 'tarmogoyf',

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { 'AS', 'AH', 'AC', 'AD', '2H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded_multiple',
    requires = {},
    category = 'tarmogoyf',

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { 'AS', 'AH', 'AC', 'AD', '2H' }
        Balatest.discard { '3S', '4H', '5C', '6D', '7H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 8)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_reset',
    requires = {},
    category = 'tarmogoyf',

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { '3S', '4H', '5C', '6D', '7H' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
--#endregion

--#region Auctioneer
Balatest.TestPlay {
    name = 'auctioneer_none',
    requires = {},
    category = 'auctioneer',

    jokers = { 'j_Bakery_Auctioneer' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_j_joker',
    requires = {},
    category = 'auctioneer',

    jokers = { 'j_Bakery_Auctioneer', 'j_joker' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_j_caino',
    requires = {},
    category = 'auctioneer',

    jokers = { 'j_Bakery_Auctioneer', 'j_caino' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 30)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_twice_half',
    requires = {},
    category = 'auctioneer',

    jokers = { 'j_Bakery_Auctioneer', 'j_joker', 'j_joker' },
    dollars = 0,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
        Balatest.assert_eq(#G.jokers.cards, 2)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_twice',
    requires = {},
    category = 'auctioneer',

    jokers = { 'j_Bakery_Auctioneer', 'j_joker', 'j_joker' },
    dollars = 0,
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 6)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
--#endregion

--#region Don
Balatest.TestPlay {
    name = 'don',
    requires = {},
    category = 'don',

    jokers = { 'j_Bakery_Don' },
    dollars = 4,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(G.GAME.dollars, 1)
    end
}
--#endregion

--#region Werewolf
Balatest.TestPlay {
    name = 'werewolf_front',
    requires = {},
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'werewolf_front_flips',
    requires = {},
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_front_does_not_flip',
    requires = {},
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.discard { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back',
    requires = { 'werewolf_front_flips' },
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_does_not_flip_0',
    requires = { 'werewolf_front_flips' },
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_does_not_flip_1',
    requires = { 'werewolf_front_flips' },
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.discard { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_flips',
    requires = { 'werewolf_front_flips' },
    category = 'werewolf',

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.discard { '2S' }
        Balatest.discard { '3S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
--#endregion

--#region Spinner
Balatest.TestPlay {
    name = 'spinner_0',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 0
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 21)
    end
}
Balatest.TestPlay {
    name = 'spinner_1',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(57)
    end
}
Balatest.TestPlay {
    name = 'spinner_2',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'spinner_3',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    dollars = 0,
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 3
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 5)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_0',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 0
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 1)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_1',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 2)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_2',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 2
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 3)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_3',
    requires = {},
    category = 'spinner',

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 3
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 4)
    end
}
--#endregion

--#region Proxy
--TODO
--#endregion

--#region Sticker Sheet
Balatest.TestPlay {
    name = 'sticker_sheet_null',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_eternal',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_eternal',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', { id = 'j_golden', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_eternal',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_golden', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_perishable',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        G.jokers.cards[1]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_perishable',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[2]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_perishable',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[1]:set_perishable(true)
        G.jokers.cards[2]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_eternal_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_eternal_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { 'j_Bakery_StickerSheet', { id = 'j_golden', eternal = true } },
    execute = function()
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_eternal_rental',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_golden', eternal = true } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_order_1',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_joker', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(84)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_order_2',
    requires = {},
    category = 'sticker_sheet',

    jokers = { { id = 'j_joker', eternal = true }, { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(140)
    end
}
--#endregion

--#region 1 of Spades
Balatest.TestPlay {
    name = '1_of_spades_level_1',
    requires = {},
    category = '1_of_spades',

    jokers = { 'j_Bakery_PlayingCard' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(24)
    end
}
Balatest.TestPlay {
    name = '1_of_spades_level_2',
    requires = {},
    category = '1_of_spades',

    jokers = { 'j_Bakery_PlayingCard' },
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(128)
    end
}
--#endregion

--#region 11 of Spades
Balatest.TestPlay {
    name = '11_of_spades_level_1',
    requires = {},
    category = '11_of_spades',

    jokers = { 'j_Bakery_PlayingCard11' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(51)
    end
}
Balatest.TestPlay {
    name = '11_of_spades_level_2',
    requires = {},
    category = '11_of_spades',

    jokers = { 'j_Bakery_PlayingCard11' },
    execute = function()
        level_up_hand(nil, 'Pair', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(128)
    end
}
--#endregion

--#region Evil Steven
Balatest.TestPlay {
    name = 'evil_steven_2_4',
    requires = {},
    category = 'evil_steven',

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C', '4D', '4H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_6_8',
    requires = {},
    category = 'evil_steven',

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { '6S', '6H', '8C', '8D', '8H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_10_Q',
    requires = {},
    category = 'evil_steven',

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'TS', 'TH', 'TC', 'QD', 'QH' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 49)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_A_J_K',
    requires = {},
    category = 'evil_steven',

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'JS' }
        Balatest.play_hand { 'KS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_unscoring',
    requires = { 'evil_steven_2_4' },
    category = 'evil_steven',

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'AS', 'AH', 'AD', '2S', '4S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
--#endregion

--#region Awful Todd
Balatest.TestPlay {
    name = 'awful_todd_A_3',
    requires = {},
    category = 'awful_todd',

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { 'AS', 'AH', 'AC', '3D', '3H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_5_7',
    requires = {},
    category = 'awful_todd',

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '5S', '5H', '7C', '7D', '7H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_9_J',
    requires = {},
    category = 'awful_todd',

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '9S', '9H', '9C', 'JD', 'JH' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 49)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_10_Q_K',
    requires = {},
    category = 'awful_todd',

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { 'TS' }
        Balatest.play_hand { 'QS' }
        Balatest.play_hand { 'KS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_unscoring',
    requires = { 'awful_todd_A_3' },
    category = 'awful_todd',

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2D', 'AS', '3S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
--#endregion

--#region Joker Against Humanity
Balatest.TestPlay {
    name = 'joker_against_humanity_null',
    requires = {},
    category = 'joker_against_humanity',

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(34)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades',
    requires = {},
    category = 'joker_against_humanity',

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades_twice',
    requires = { 'joker_against_humanity_upgrades' },
    category = 'joker_against_humanity',

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(56)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades_kept',
    requires = { 'joker_against_humanity_upgrades_twice' },
    category = 'joker_against_humanity',

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.next_round()
        Balatest.q(function()
            level_up_hand(nil, 'High Card', true, 1)
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(102)
    end
}
--#endregion

--#region Card Sleeve
--Todo
--#endregion

--#region Bongard Problem
Balatest.TestPlay {
    name = 'bongard_problem_standard',
    requires = {},
    category = 'bongard_problem',

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(56)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_same_suit',
    requires = {},
    category = 'bongard_problem',

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4H', '5D', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(200)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_single',
    requires = {},
    category = 'bongard_problem',

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_single_wild',
    requires = {},
    category = 'bongard_problem',

    jokers = { 'j_Bakery_BongardProblem' },
    deck = { cards = { { s = 'S', r = '2', e = 'm_wild' }, { s = 'S', r = '3' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
--#endregion

--#region Coin Slot
Balatest.TestPlay {
    name = 'coin_slot_null',
    requires = {},
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_inserted',
    requires = {},
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 10,
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 5)
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_inserted_twice',
    requires = { 'coin_slot_inserted' },
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 10,
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.q(function()
            return Bakery_API.default_can_use(G.jokers.cards[1])
        end)
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_chips(49)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_no_debt',
    requires = {},
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'coin_slot_no_debt_click',
    requires = {},
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 0,
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_yes_debt',
    requires = {},
    category = 'coin_slot',

    jokers = { 'j_Bakery_CoinSlot', 'j_credit_card' },
    dollars = 0,
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, -5)
        Balatest.assert_chips(28)
    end
}
--#endregion

--#region Pyrite
Balatest.TestPlay {
    name = 'pyrite_normal',
    requires = {},
    category = 'pyrite',

    jokers = { 'j_Bakery_Pyrite' },
    hand_size = 5,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 8)
    end
}
Balatest.TestPlay {
    name = 'pyrite_full',
    requires = {},
    category = 'pyrite',

    jokers = { 'j_Bakery_Pyrite' },
    deck = { cards = { { s = 'S', r = 'A' } } },
    hand_size = 1,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
    end
}
--#endregion

--#region Snowball
Balatest.TestPlay {
    name = 'snowball_1',
    requires = {},
    category = 'snowball',

    jokers = { 'j_joker', 'j_joker', 'j_Bakery_Snowball' },
    execute = function()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(154)
    end
}
Balatest.TestPlay {
    name = 'snowball_5',
    requires = {},
    category = 'snowball',

    jokers = { 'j_joker', 'j_joker', 'j_Bakery_Snowball' },
    execute = function()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(210)
    end
}
--#endregion

--#region Get Out of Jail Free Card
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_null',
    requires = {},
    category = 'get_out_of_jail_free_card',

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_used',
    requires = {},
    category = 'get_out_of_jail_free_card',

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_used_across_rounds',
    requires = { 'get_out_of_jail_free_card_used' },
    category = 'get_out_of_jail_free_card',

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_use_twice',
    requires = {},
    category = 'get_out_of_jail_free_card',

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function()
            G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } }
            return true
        end)
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
--#endregion

--#region Transparent Back Buffer
Balatest.TestPlay {
    name = 'transparent_back_buffer_1',
    requires = {},
    category = 'transparent_back_buffer',

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(49)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_k_r',
    requires = {},
    category = 'transparent_back_buffer',

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C', '3D', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(1768)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_r_k',
    requires = {},
    category = 'transparent_back_buffer',

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2H', '2S', '2D', '3C', '3D' }
    end,
    assert = function()
        Balatest.assert_chips(1768)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_wild',
    requires = {},
    category = 'transparent_back_buffer',

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    deck = { cards = { { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = '2' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', 'AS', 'AS', 'AS' }
    end,
    assert = function()
        Balatest.assert_chips(9890)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_stone',
    requires = {},
    category = 'transparent_back_buffer',

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    deck = { cards = { { s = 'S', r = 'A', e = 'm_stone' }, { s = 'S', r = '2' } } },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_chips(55)
    end
}
--#endregion

--#region Tier List
Balatest.TestPlay {
    name = 'tier_list_solo',
    requires = {},
    category = 'tier_list',

    jokers = { 'j_Bakery_TierList' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden',
    requires = {},
    category = 'tier_list',

    jokers = { 'j_Bakery_TierList', 'j_golden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_golden',
    requires = {},
    category = 'tier_list',

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_golden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_stone',
    requires = {},
    category = 'tier_list',

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_stone' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_stone_chicot',
    requires = {},
    category = 'tier_list',

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_stone', 'j_chicot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
--#endregion

--#region Tag
--Todo
--#endregion

--#region Glass Cannon
Balatest.TestPlay {
    name = 'glass_cannon_no_shatter',
    requires = {},
    category = 'glass_cannon',

    jokers = { 'j_Bakery_GlassCannon' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'glass_cannon_yes_shatter',
    requires = {},
    category = 'glass_cannon',

    jokers = { 'j_order', 'j_order', 'j_Bakery_GlassCannon' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(25920)
        Balatest.assert_eq(#G.jokers.cards, 2)
    end
}
Balatest.TestPlay {
    name = 'glass_cannon_yes_shatter_avoided',
    requires = {},
    category = 'glass_cannon',

    jokers = { 'j_Bakery_GlassCannon', 'j_order', 'j_order' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(25920)
        Balatest.assert_eq(#G.jokers.cards, 3)
    end
}
--#endregion
