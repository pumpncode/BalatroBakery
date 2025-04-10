return {
    descriptions = {
        BakeryCharm = {
        },
        Other = {
            Bakery_charm = {
                name = "Charm",
                text = { "Only one charm may", "be equipped at a time,", "purchasing a new charm", "replaces an old one" }
            },
            undiscovered_bakerycharm = {
                name = "Undiscovered",
                text = { "Equip this charm", "in an unseeded run", "to learn what it does" }
            }
        }
    },
    misc = {
        v_text = {
            ch_c_Bakery_Balanced = { "{C:mult}Mult{} cannot exceed {C:chips}Chips{}" },
            ch_c_Bakery_Vagabond = { "{C:money}Money{} cannot exceed {C:money}$#1#" },
            ch_c_Bakery_Sprint_Small = { "{C:attention}Small Blinds{} must be skipped" },
            ch_c_Bakery_Sprint_Big = { "{C:attention}Big Blinds{} must be skipped" },
        },
        dictionary = {
            k_bakerycharm = "Charm",
            k_BakeryCharmInfo = { "Only one charm may be equipped at a time,",
                "purchasing a new charm replaces an old one." },
            b_Bakery_equip = "EQUIP",
            b_Bakery_ante = "(Ante)"
        },
    }
}
