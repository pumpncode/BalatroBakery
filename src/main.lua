Bakery_API = {}
Bakery_API.load_stack = {}
function Bakery_API.load(file)
    table.insert(Bakery_API.load_stack, file)
    local path = ''
    for _, part in ipairs(Bakery_API.load_stack) do
        path = path .. '/' .. part
    end
    local ret = assert(SMODS.load_file('src/' .. path .. '.lua'))()
    table.remove(Bakery_API.load_stack)
    return ret
end

Bakery_API.load('util')
Bakery_API.load('joker')
Bakery_API.load('back')
Bakery_API.load('tag')
Bakery_API.load('blind')
Bakery_API.load('challenge')
Bakery_API.load('consumable')
Bakery_API.load('enhancement')

SMODS.Atlas {
    key = "modicon",
    path = "Icon.png",
    px = 34,
    py = 34
}
