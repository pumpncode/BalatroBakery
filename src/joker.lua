Bakery_API.guard(function()
    function Bakery_API.Joker(o)
        o.name = o.name or o.key
        o.atlas = o.atlas or 'Bakery'
        o.pos = o.pos or {
            x = 0.5,
            y = 0.5
        }
        return Bakery_API.credit(SMODS.Joker(o))
    end
end)
Bakery_API.guard(function()
    function Bakery_API.get_proxied_joker()
        if G.jokers and G.jokers.cards then
            local other_joker = nil
            local latest = -1
            for _, other in pairs(G.jokers.cards) do
                if other.config.center ~= G.P_CENTERS.j_Bakery_Proxy and other.ability.Bakery_purchase_index and
                    other.ability.Bakery_purchase_index > latest and other.config.center.blueprint_compat then
                    latest = other.ability.Bakery_purchase_index
                    other_joker = other
                end
            end
            return other_joker
        end
    end
end)
Bakery_API.load('sleeve')
Bakery_API.guard(function()
    Bakery_API.black_suits = { "Spades", "Clubs" }
    Bakery_API.red_suits = { "Hearts", "Diamonds" }
    function Bakery_API.is_any_suit(card, suits)
        for _, s in pairs(suits) do
            if card:is_suit(s) then
                return true
            end
        end
        return false
    end

    function Bakery_API.alternates_suits(hand, first, second)
        if not first then
            return Bakery_API.alternates_suits(hand, Bakery_API.red_suits, Bakery_API.black_suits) or
                Bakery_API.alternates_suits(hand, Bakery_API.black_suits, Bakery_API.red_suits)
        end

        for i = 1, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], first) then
                return false
            end
        end

        for i = 2, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], second) then
                return false
            end
        end

        return true
    end
end)
Bakery_API.guard(function()
    Bakery_API.rarities = {
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Legendary = 4
    }
    function Bakery_API.count_rarities()
        if not G.jokers then
            return 0
        end
        local count = 0
        local rarities = {}
        for _, v in ipairs(G.jokers.cards) do
            local rarity = Bakery_API.rarities[v.config.center.rarity] or v.config.center.rarity
            if not rarities[rarity] then
                rarities[rarity] = true
                count = count + 1
            end
        end
        return count
    end
end)
