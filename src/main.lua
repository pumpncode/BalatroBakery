Bakery_API = {}
function Bakery_API.load(file)
    assert(SMODS.load_file('src/' .. file))()
end

Bakery_API.load('util.lua')
Bakery_API.load('joker.lua')
Bakery_API.load('back.lua')
Bakery_API.load('tag.lua')
Bakery_API.load('blind.lua')
Bakery_API.load('challenge.lua')
Bakery_API.load('consumable.lua')
Bakery_API.load('enhancement.lua')

SMODS.Atlas {
    key = "modicon",
    path = "Icon.png",
    px = 34,
    py = 34
}
