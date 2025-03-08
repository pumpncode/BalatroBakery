-- KEEP_LITE
return {
    -- END_KEEP_LITE
    descriptions = {
        Joker = {
            j_Bakery_Tarmogoyf = {
                name = 'Tarmogoyf',
                text = {'{C:red}+#1#{} Mult for each {C:attention}unique{}', 'rank discarded this {C:attention}round',
                        '{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)'}
            },
            j_Bakery_Auctioneer = {
                name = 'Auctioneer',
                text = {"When {C:attention}blind{} is selected", "{C:money}sells{} Joker to the right",
                        "for {C:attention}#1#x{} its sell value"}
            },
            j_Bakery_Don = {
                name = 'Don',
                text = {"{X:mult,C:white}X#1#{} Mult", "Lose {C:money}$#2#{} per played hand"}
            },
            j_Bakery_Werewolf = {
                name = 'Werewolf (Day)',
                text = {"{X:mult,C:white}X#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                        "if {C:attention}no discards{} were used"}
            },
            j_Bakery_Werewolf_Back = {
                name = 'Werewolf (Night)',
                text = {"{X:mult,C:white}X#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                        "if {C:attention}2 or more", "{C:attention}discards{} were used"}
            },
            j_Bakery_Spinner = {
                name = "Spinner",
                text = {"Gives the {C:attention}bottom{} bonus", "Rotates {C:attention}clockwise",
                        "at end of {C:attention}round"}
            },
            j_Bakery_Proxy = {
                name = "Proxy",
                text = {"Copies ability of", "most recently", "purchased {C:attention}Joker{}",
                        "{C:inactive}(Currently {C:attention}#1#{C:inactive})"},
                unlock = {"Have {C:attention}#1#", "and {C:attention}#2#", "simultaneously"}
            },
            j_Bakery_StickerSheet = {
                name = "Sticker Sheet",
                text = {"Each {C:attention}stickered{} Joker", "gives {X:mult,C:white}X#1#{} Mult"},
                unlock = {"Have an {C:attention}eternal", "{C:attention}rental{} Joker"}
            },
            j_Bakery_PlayingCard = {
                name = "1 of Spades",
                text = {"Gives {C:mult}Mult{} and {C:chips}Chips", "of {C:attention}High Card"},
                unlock = {"Get {C:attention}High Card", "to level {C:attention}#1#"}
            },
            j_Bakery_PlayingCard11 = {
                name = "11 of Spades",
                text = {"Gives {C:mult}Mult{} and {C:chips}Chips", "of {C:attention}Pair"},
                unlock = {"Get {C:attention}Pair", "to level {C:attention}#1#"}
            },
            j_Bakery_EvilSteven = {
                name = "Evil Steven",
                text = {"{C:red}Destroys{} all scored cards", "with {C:attention}even{} rank",
                        "{C:inactive}(2, 4, 6, 8, 10)"}
            },
            j_Bakery_AwfulTodd = {
                name = "Awful Todd",
                text = {"{C:red}Destroys{} all scored cards", "with {C:attention}odd{} rank",
                        "{C:inactive}(A, 3, 5, 7, 9)"}
            },
            j_Bakery_JokerAgainstHumanity = {
                name = "Joker Against Humanity",
                text = {"Gains {C:mult}+#1#{} Mult", "when played {C:attention}poker hand{}",
                        "is {C:attention}level 1{}", "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}"}
            },
            j_Bakery_CardSleeve = {
                name = "Card Sleeve",
                text = {"{C:attention}Holds{} one", "playing card"}
            },
            j_Bakery_BongardProblem = {
                name = "Bongard Problem",
                text = {"{X:mult,C:white}X#1#{} Mult if", "leftmost and rightmost", "scoring cards are",
                        "different {C:attention}suits"}
            },
            j_Bakery_CoinSlot = {
                name = "Coin Slot",
                text = {"Gains {C:mult}+#1#{} Mult", "per {C:money}$#2#{} put", "into the slot",
                        "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"}
            },
            j_Bakery_Pyrite = {
                name = "Pyrite",
                text = {"Draw {C:attention}#1#{} extra cards", "in {C:attention}first hand{} of round"}
            },
            j_Bakery_Snowball = {
                name = "Snowball",
                text = {"Gains {X:mult,C:white}X#1#{} Mult", "when {C:attention}Blind{} is selected",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"}
            },
            j_Bakery_GetOutOfJailFreeCard = {
                name = "Get Out of Jail Free Card",
                text = {"{C:attention}Use{} to get {X:mult,C:white}X#1#{} Mult", "for {C:attention}one hand"}
            },
            j_Bakery_TransparentBackBuffer = {
                name = "Transparent Back Buffer",
                text = {"{C:mult}+#1#{} Mult per scored card", "if played hand alternates",
                        "{C:attention}red{} and {C:attention}black{} suits"}
            },
            j_Bakery_TierList = {
                name = "Tier List",
                text = {"{X:mult,C:white}X#1#{} Mult for each {C:attention}unique",
                        "{C:attention}rarity{} among your {C:attention}Jokers{}",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"}
            },
            j_Bakery_Tag = {
                name = "Tag",
                text = {"{C:attention}Tags{} give {X:mult,C:white}X#1#{} Mult"}
            }
        },
        Tag = {
            tag_Bakery_RetriggerTag = {
                name = 'Retrigger Tag',
                text = {"Shop has a free", "{C:dark_edition}Retrigger Joker"}
            },
            tag_Bakery_ChocolateTag = {
                name = "Chocolate Tag",
                text = {"Gives {C:chips}+#1# Chips{} and {C:mult}+#2# Mult{} when scored",
                        "{C:chips}-#3# Chips{} and {C:mult}-#4# Mult{0} for every hand played"}
            },
            tag_Bakery_PolyTag = {
                name = "Poly Tag",
                text = {"Gives {X:mult,C:white}X#1#{} Mult when scored", "Lasts {C:attention}1{} round"}
            },
            tag_Bakery_PennyTag = {
                name = "Penny Tag",
                text = {"Scored cards give {C:money}$#1#", "for the next {C:attention}#2#{} hands"}
            },
            tag_Bakery_BlankTag = {
                name = "Blank Tag",
                text = {"{C:inactive}Does nothing?"}
            },
            tag_Bakery_AntiTag = {
                name = "Anti Tag",
                text = {"{C:dark_edition}+1{} Joker slot"}
            }
        },
        Back = {
            b_Bakery_Violet = {
                name = "Violet Deck",
                text = {"Gives {X:mult,C:white}X#1#{} Mult"},
                unlock = {"Defeat {C:purple}#1#"}
            },
            b_Bakery_House = {
                name = "House Deck",
                text = {"Each played card has a", "{C:green}#1# in #2#{} chance", "to change rank and suit",
                        "after a hand is scored"},
                unlock = {"Win a run with", "{C:attention}#1#{}", "on any difficulty"}
            },
            b_Bakery_Credit = {
                name = "Credit Deck",
                text = {"Start with extra {C:money}$#1#{}", "Earn {C:red}no money{}", "from any source"},
                unlock = {"Win a run with", "{C:attention}#1#{}", "on at least", "{V:1}#2#{} difficulty"}
            }
        },
        Sleeve = {
            sleeve_Bakery_Violet = {
                name = "Violet Sleeve",
                text = {"Gives {X:mult,C:white}X#1#{} Mult"}
            },
            sleeve_Bakery_House = {
                name = "House Sleeve",
                text = {"Each played card has a", "{C:green}#1# in #2#{} chance", "to change rank and suit",
                        "after a hand is scored"}
            },
            sleeve_Bakery_House_alt = {
                name = "House Sleeve",
                text = {"Cards are {C:green}twice{} as", "likely to change and", "can gain modifications"}
            },
            sleeve_Bakery_Credit = {
                name = "Credit Sleeve",
                text = {"Start with extra {C:money}$#1#{}", "Earn {C:red}no money{}", "from any source"}
            },
            sleeve_Bakery_Credit_alt = {
                name = "Credit Sleeve",
                text = {"Start with extra {C:money}$#1#{}", "Lose {C:red}$1{} per card played"}
            }
        },
        Blind = {
            bl_Bakery_Aleph = {
                name = "The Leader",
                text = {"-1 Hand", "-1 Discard"}
            },
            bl_Bakery_Tsadi = {
                name = "The Attrition",
                text = {"{C:red}-#1#{} Mult", "before scoring"}
            }
        },
        Spectral = {
            c_Bakery_Astrology = {
                name = "Astrology",
                text = {"{C:money}Sell{} all {C:attention}hand levels", "for {C:money}$#1#{} each"}
            },
            c_Bakery_TimeMachine = {
                name = "Time Machine",
                text = {"Enhances {C:attention}#1#{} selected", "card into a", "{C:attention}#2#"}
            }
        },
        Tarot = {
            c_Bakery_Scribe = {
                name = "The Scribe",
                text = {"Create {C:attention}#1#{} {C:dark_edition}Carbon{}", "copy of {C:attention}#2#{} selected", "{C:attention}playing card{} or {C:attention}Joker", "{C:inactive}(Must have room)", "{C:inactive}(Removes {C:eternal}Eternal{C:inactive} from copy)"}
            }
        },
        Enhanced = {
            m_Bakery_TimeWalk = {
                name = "Time Walk",
                text = {"{C:blue}+1{} Hand", "no rank or suit"}
            }
        },
        Edition = {
            e_Bakery_Carbon = {
                name = "Carbon",
                text = {"{C:red}Self-destructs", "after scoring"}
            }
        }
    },
    -- KEEP_LITE
    misc = {
        v_text = {
            ch_c_Bakery_Balanced = {"{C:mult}Mult{} cannot exceed {C:chips}Chips{}"},
            ch_c_Bakery_Vagabond = {"{C:money}Money{} cannot exceed {C:money}$#1#"}
        },
        -- END_KEEP_LITE
        challenge_names = {
            c_Bakery_Balanced = "Balanced",
            c_Bakery_Vagabond = "Vagabond"
        },
        dictionary = {
            b_Bakery_store = "STORE",
            b_Bakery_return = "GET"
        },
        v_dictionary = {
            b_Bakery_deposit = "DEPOSIT $#1#",
            b_Bakery_ante_times = "(Ante*#1#)",
            v_Bakery_artist = "Artist: #1#"
        },
        labels = {
            Bakery_Carbon = "Carbon"
        }
        -- KEEP_LITE
    }
}
