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
                text = {"Each card has a {C:green}#1# in #2#{} chance", "to change rank and suit",
                        "after a hand is scored"},
                unlock = {"Win a run with", "{C:attention}#1#{}", "on any difficulty"}
            }
        }
    }
}
