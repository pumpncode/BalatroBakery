return {
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
                text = {"{X:mult,C:white}x#1#{} Mult", "Lose {C:money}$#2#{} per played hand"}
            },
            j_Bakery_Werewolf = {
                name = 'Werewolf (Day)',
                text = {"{X:mult,C:white}x#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                        "if {C:attention}no discards{} were used"}
            },
            j_Bakery_Werewolf_Back = {
                name = 'Werewolf (Night)',
                text = {"{X:mult,C:white}x#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                        "if {C:attention}2 or more", "{C:attention}discards{} were used"}
            },
            j_Bakery_Spinner = {
                name = "Spinner",
                text = {"Gives the {C:attention}bottom{} bonus", "Rotates {C:attention}clockwise",
                        "at end of {C:attention}round"}
            },
            j_Bakery_Proxy = {
                name = "Proxy",
                text = {"Copies ability of", "most recently", "purchased {C:attention}Joker{}", "{C:inactive}(Currently {C:attention}#1#{C:inactive})"},
                unlock = {"Have {C:attention}#1#", "and {C:attention}#2#", "simultaneously"}
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
                text = {"Gives {X:mult,C:white}x#1#{} Mult when scored", "Lasts {C:attention}1{} round"}
            }
        },
        Back = {
            b_Bakery_Violet = {
                name = "Violet Deck",
                text = {"Gives {X:mult,C:white}x#1#{} Mult"},
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
                text = {"Gives {X:mult,C:white}x#1#{} Mult"}
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
            }
        },
        Spectral = {
            c_Bakery_Astrology = {
                name = "Astrology",
                text = {"{C:money}Sell{} all {C:attention}hand levels", "for {C:money}$#1#{} each"}
            }
        }
    },
    misc = {
        challenge_names = {
            c_Bakery_Balanced = "Balanced",
            c_Bakery_Vagabond = "Vagabond"
        },
        v_text = {
            ch_c_Bakery_Balanced = {"{C:mult}Mult{} cannot exceed {C:chips}Chips{}"},
            ch_c_Bakery_Vagabond = {"{C:money}Money{} cannot exceed {C:money}$#1#"}
        }
    }
}
