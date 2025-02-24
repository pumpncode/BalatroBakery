-- KEEP_LITE
Bakery_API = Bakery_API or {}
if not Bakery_API.Provider then
    Bakery_API.Provider = "Bakery_Lite"
    -- END_KEEP_LITE
    Bakery_API.Provider = "Bakery"
    -- KEEP_LITE
end
Bakery_API.load_stack = {}
function Bakery_API.guard(f)
    local provider = "Bakery_Lite"
    -- END_KEEP_LITE
    provider = "Bakery"
    -- KEEP_LITE
    if Bakery_API.Provider == provider then
        f()
    end
end
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
Bakery_API.load('contributor')
Bakery_API.load('joker')
Bakery_API.load('back')
Bakery_API.load('tag')
Bakery_API.load('blind')
Bakery_API.load('challenge')
Bakery_API.load('consumable')
Bakery_API.load('enhancement')
-- END_KEEP_LITE

SMODS.Atlas {
    key = "modicon",
    path = "Icon.png",
    px = 34,
    py = 34
}
