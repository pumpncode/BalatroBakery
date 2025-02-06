assert(SMODS.load_file('src/util.lua'))()
assert(SMODS.load_file('src/joker.lua'))()
assert(SMODS.load_file('src/back.lua'))()
assert(SMODS.load_file('src/tag.lua'))()
assert(SMODS.load_file('src/blind.lua'))()
assert(SMODS.load_file('src/challenge.lua'))()
assert(SMODS.load_file('src/consumable.lua'))()
assert(SMODS.load_file('src/enhancement.lua'))()

SMODS.Atlas {
    key = "modicon",
    path = "Icon.png",
    px = 34,
    py = 34
}
