-- KEEP_LITE
local function all_suits(n, hand)
    local suits = SMODS.Suit.obj_buffer
    local counts = {}
    local vals = {}
    for j = 1, #suits do
        vals[j] = {}
        counts[j] = 0
        for i = 1, #hand do
            if hand[i]:is_suit(suits[j], nil, true) then
                counts[j] = counts[j] + 1
                vals[j][#vals[j] + 1] = hand[i]
            end
        end
    end
    local ret = {}
    for k, v in pairs(counts) do
        if v >= n then
            ret[#ret + 1] = vals[k]
        end
    end
    return ret
end

Bakery_API.guard(function()
    SMODS.ObjectType {
        key = "BakeryCharm"
    }

    Bakery_API.Charm = SMODS.Center:extend {
        required_params = { "key" },
        unlocked = true,
        discovered = false,
        pos = {
            x = 0,
            y = 0
        },
        cost = 8,
        config = {},
        consumeable = true,
        set = 'BakeryCharm',
        class_prefix = 'BakeryCharm',
        pools = { "BakeryCharm" },
        set_card_type_badge = function(self, card, badges)
            badges[#badges + 1] = create_badge(localize('k_Bakery_charm'), G.C.DARK_EDITION, G.C.WHITE, 1.2)
        end,
        load = function(self, card, cardTable, other_card)
            card.T.h = G.CARD_W
            card.T.w = G.CARD_W
        end,
        register = function(self)
            local raw_obj_loc_vars = self.loc_vars
            self.loc_vars = function(self, info_queue, card)
                info_queue[#info_queue + 1] = {
                    set = "Other",
                    key = "Bakery_charm"
                }
                if raw_obj_loc_vars then
                    return raw_obj_loc_vars(self, info_queue, card)
                end
            end
            Bakery_API.Charm.super.register(self)
        end,
        equip = function(self, card)
        end,
        unequip = function(self, card)
        end
    }

    SMODS.Atlas {
        key = "CharmsUtil",
        px = 68,
        py = 68,
        path = "BakeryCharmsUtil.png"
    }

    SMODS.UndiscoveredSprite {
        key = "BakeryCharm",
        atlas = "CharmsUtil",
        pos = {
            x = 0,
            y = 1
        },
        overlay_pos = {
            x = 0,
            y = 2
        }
    }

    G.FUNCS.your_collection_Bakery_Charms_page = function(args)
        if not args or not args.cycle_config then
            return
        end
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards, 1, -1 do
                local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
                c:remove()
                c = nil
            end
        end
        for i = 1, 5 do
            for j = 1, #G.your_collection do
                local center = G.P_CENTER_POOLS.BakeryCharm[i + (j - 1) * 5 +
                (5 * #G.your_collection * (args.cycle_config.current_option - 1))]
                if not center then
                    break
                end
                local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
                    G.CARD_W, G.CARD_W, G.P_CARDS.empty, center)
                card.sticker = get_joker_win_sticker(center)
                G.your_collection[j]:emplace(card)
            end
        end
        INIT_COLLECTION_CARD_ALERTS()
    end

    SMODS.current_mod.custom_collection_tabs = function()
        local tally = 0
        for _, v in pairs(G.P_CENTER_POOLS.BakeryCharm) do
            if v.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked then
                tally = tally + 1
            end
        end
        return { UIBox_button {
            button = 'your_collection_Bakery_Charms',
            id = 'your_collection_Bakery_Charms',
            label = { localize('k_Bakery_charms') },
            count = {
                tally = tally,
                of = #G.P_CENTER_POOLS.BakeryCharm
            },
            minw = 5
        } }
    end
    function G.FUNCS.your_collection_Bakery_Charms()
        G.SETTINGS.paused = true
        G.FUNCS.overlay_menu {
            definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.BakeryCharm, { 5, 5 }, {
                snap_back = true,
                infotip = localize('k_BakeryCharmInfo'),
                hide_single_page = true,
                collapse_single_page = true,
                h_mod = 0.65,
                modify_card = function(card, center, i, j)
                    card.T.h = card.T.w
                end
            })
        }
    end

    G.BakeryCharm_locked = {
        unlocked = false,
        max = 1,
        name = "Locked",
        pos = {
            x = 0,
            y = 0
        },
        set = "BakeryCharm",
        atlas = "Bakery_CharmsUtil",
        cost_mult = 1.0,
        config = {}
    }

    local raw_Card_set_sprites = Card.set_sprites
    function Card:set_sprites(center, front)
        raw_Card_set_sprites(self, center, front)
        if center and center.set == 'BakeryCharm' and not center.unlocked then
            self.children.center.atlas = G.ASSET_ATLAS.Bakery_CharmsUtil
            self.children.center.scale = {
                x = G.ASSET_ATLAS.Bakery_CharmsUtil.px,
                y = G.ASSET_ATLAS.Bakery_CharmsUtil.py
            }
            self.children.center.scale_mag = G.ASSET_ATLAS.Bakery_CharmsUtil.px / (self.children.center.VT.W or 1)/(G.ASSET_ATLAS.Bakery_CharmsUtil.py / (self.children.center.VT.H or 1))
            self.children.center:set_sprite_pos({
                x = 0,
                y = 0
            })
        end
    end

    sendInfoMessage("Card:set_sprites() patched. Reason: Charm Unlocking", "Bakery")

    function Bakery_API.get_charm_count()
        return (G.GAME.starting_params.Bakery_charms_in_shop or 1) + (G.GAME.modifiers.Bakery_extra_charms or 0)
    end

    function Bakery_API.get_next_charms(ret, count)
        local ret = ret or {
            spawn = {}
        }
        local _pool, _pool_key = get_current_pool('BakeryCharm')
        local already = 0
        G.GAME.current_round.Bakery_charm = G.GAME.current_round.Bakery_charm or {
            spawn = {}
        }
        for _, v in ipairs(_pool) do
            if G.GAME.current_round.Bakery_charm.spawn[v] then
                already = already + 1
            end
        end
        for i = 1, math.min(SMODS.size_of_pool(_pool) - already, count or Bakery_API.get_charm_count()) do
            local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
            local it = 1
            while center == 'UNAVAILABLE' or G.GAME.current_round.Bakery_charm.spawn[center] do
                it = it + 1
                center = pseudorandom_element(_pool, pseudoseed(_pool_key .. '_resample' .. it))
            end

            ret[#ret + 1] = center
            ret.spawn[center] = true
        end
        return ret
    end

    function Bakery_API.add_charms_to_shop()
        local charms_to_spawn = 0
        G.GAME.current_round.Bakery_charm = G.GAME.current_round.Bakery_charm or {
            spawn = {}
        }
        for _ in pairs(G.GAME.current_round.Bakery_charm.spawn) do
            charms_to_spawn = charms_to_spawn + 1
        end
        if charms_to_spawn < Bakery_API.get_charm_count() then
            Bakery_API.get_next_charms(G.GAME.current_round.Bakery_charm)
        end
        for _, key in ipairs(G.GAME.current_round.Bakery_charm or {}) do
            if G.P_CENTERS[key] and G.GAME.current_round.Bakery_charm.spawn[key] and key ~= 'j_joker' then
                Bakery_API.add_charm_to_shop(key, 'shop_voucher')
            end
        end
    end

    function Bakery_API.add_charm_to_shop(key, source)
        assert(key, "Expected a key")
        assert(G.P_CENTERS[key], "Invalid charm key: " .. key)
        local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w / 2, G.shop_vouchers.T.y, G.CARD_W, G.CARD_W,
            G.P_CARDS.empty, G.P_CENTERS[key], {
                bypass_discovery_center = true,
                bypass_discovery_ui = true
            })
        card[source] = true
        create_shop_card_ui(card, 'Charm', G.shop_vouchers)
        card:start_materialize()
        G.shop_vouchers:emplace(card)
        G.shop_vouchers.config.card_limit = #G.shop_vouchers.cards
        return card
    end

    function Bakery_API.equip_button(card)
        return {
            n = G.UIT.ROOT,
            config = {
                ref_table = card,
                minw = 1.1,
                maxw = 1.3,
                padding = 0.1,
                align = 'bm',
                colour = G.C.GREEN,
                shadow = true,
                r = 0.08,
                minh = 0.94,
                func = 'Bakery_can_equip',
                one_press = true,
                button = 'Bakery_equip_from_shop',
                hover = true
            },
            nodes = { {
                n = G.UIT.T,
                config = {
                    text = localize('b_Bakery_equip'),
                    colour = G.C.WHITE,
                    scale = 0.4
                }
            } }
        }
    end

    local to_big = to_big or function(...) return ... end
    G.FUNCS.Bakery_can_equip = function(e)
        if to_big(e.config.ref_table.cost) > to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.GREEN
            e.config.button = 'Bakery_equip_from_shop'
        end
    end
    G.FUNCS.Bakery_equip_from_shop = function(e, mute, nosave)
        e.config.button = nil
        local card = e.config.ref_table
        local area = card.area
        local prev_state = G.STATE
        local delay_fac = 1

        G.TAROT_INTERRUPT = G.STATE
        G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK) or
            (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK) or
            (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK) or
            (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK) or
            (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK) or G.STATES.PLAY_TAROT

        G.CONTROLLER.locks.use = true

        if card.children.use_button then
            card.children.use_button:remove();
            card.children.use_button = nil
        end
        if card.children.price then
            card.children.price:remove();
            card.children.price = nil
        end

        if card.area then
            card.area:remove_card(card)
        end

        delay(0.1)
        G.GAME.round_scores.cards_purchased.amt = G.GAME.round_scores.cards_purchased.amt + 1
        e.config.ref_table:Bakery_equip()

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                G.STATE = prev_state
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = false

                if area and area.cards[1] then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:snap_to({
                                node = G.shop:get_UIE_by_ID('next_round_button')
                            })
                            return true
                        end
                    }))
                end
                return true
            end
        }))
    end

    function Card:Bakery_equip()
        if self.config.center.set ~= 'BakeryCharm' then
            return
        end
        stop_use()
        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        if self.shop_voucher then
            G.GAME.current_round.Bakery_charm.spawn[self.config.center_key] = false
        end

        if G.GAME.Bakery_charm then
            G.P_CENTERS[G.GAME.Bakery_charm]:unequip(G.Bakery_charm_area.cards[1])
            G.GAME.used_jokers[G.GAME.Bakery_charm] = nil
            if not G.Bakery_charm_area.cards[1] then
                sendWarnMessage("No charm was found in G.Bakery_charm_area to destroy.", "Bakery")
            else
                G.Bakery_charm_area.cards[1]:start_dissolve()
            end
        end
        G.GAME.Bakery_charm = self.config.center_key
        G.GAME.used_jokers[self.config.center_key] = true
        G.Bakery_charm_area:emplace(self)
        if self.cost ~= 0 then
            ease_dollars(-self.cost)
            inc_career_stat('c_shop_dollars_spent', self.cost)
        end
        -- TODO: stat tracking
        -- inc_career_stat('c_vouchers_bought', 1)
        -- set_voucher_usage(self)

        self.config.center:equip(self)
        delay(0.6)
        SMODS.calculate_context({
            buying_card = true,
            card = self
        })

        if G.GAME.modifiers.inflation then
            G.GAME.inflation = G.GAME.inflation + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then
                            v:set_cost()
                        end
                    end
                    return true
                end
            }))
        end
    end

    function Bakery_API.create_charm_area()
        G.Bakery_charm_area = CardArea(0, 0, 0.95 * G.CARD_W, 0.95 * G.CARD_W, {
            card_limit = 1,
            type = 'joker',
            highlight_limit = 1
        })
        G.Bakery_charm_area.ARGS.invisible_area_types = {
            joker = 1
        }
    end

    local raw_set_screen_positions = set_screen_positions
    function set_screen_positions()
        raw_set_screen_positions()
        if G.STAGE == G.STAGES.RUN and G.Bakery_charm_area then
            G.Bakery_charm_area.T.x = G.TILE_W - G.Bakery_charm_area.T.w - 0.5
            G.Bakery_charm_area.T.y = G.TILE_H - G.deck.T.h - 1.2 * G.Bakery_charm_area.T.h
        end
    end

    local raw_CardArea_can_highlight = CardArea.can_highlight
    function CardArea:can_highlight(card)
        return self ~= G.Bakery_charm_area and raw_CardArea_can_highlight(self, card)
    end

    sendInfoMessage("set_screen_positions() and CardArea:can_highlight() patched. Reason: Charm rendering", "Bakery")

    SMODS.PokerHandPart {
        key = 's_2',
        func = function(hand)
            return all_suits(2, hand)
        end
    }
    SMODS.PokerHandPart {
        key = 's_3',
        func = function(hand)
            return all_suits(3, hand)
        end
    }
    SMODS.PokerHandPart {
        key = 's_all_pairs',
        func = function(hand)
            local _2 = all_suits(2, hand)
            if not next(_2) then
                return {}
            end
            return { SMODS.merge_lists(_2) }
        end
    }
end)
-- END_KEEP_LITE

SMODS.Atlas {
    key = "Charms",
    px = 68,
    py = 68,
    path = "BakeryCharms.png"
}

local raw_get_flush = get_flush
function get_flush(hand)
    if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Palette' then
        local suits = SMODS.Suit.obj_buffer
        local suit = {}
        local count = 0
        for j = 1, #suits do
            for i = 1, #hand do
                if not suit[j] and hand[i]:is_suit(suits[j], nil, true) then
                    suit[j] = true;
                    count = count + 1
                end
            end
        end
        if count >= 4 then
            return { hand }
        end
    end
    return raw_get_flush(hand)
end

Bakery_API.Charm {
    key = "Palette",
    pos = {
        x = 0,
        y = 0
    },
    atlas = 'Charms',
    unlocked = false,
    locked_loc_vars = function(self, info_queue, card)
        return {
            vars = { 52 }
        }
    end,
    check_for_unlock = function(self, args)
        if args.type ~= 'modify_deck' or not G.playing_cards then
            return
        end
        local suits = SMODS.Suit.obj_buffer
        local suit = nil
        for _, s in pairs(suits) do
            local count = 0
            for _, v in pairs(G.playing_cards) do
                if v:is_suit(s, true) then
                    count = count + 1
                    if count >= 52 then
                        return true
                    end
                end
            end
        end
    end
}

Bakery_API.no_update_joker_display = false

local raw_evaluate_poker_hand = evaluate_poker_hand
function evaluate_poker_hand(hand)
    if G.GAME.Bakery_charm ~= 'BakeryCharm_Bakery_AnaglyphLens' or #hand == 0 then
        return raw_evaluate_poker_hand(hand)
    end
    local dup = hand[1]
    local x = hand[1].T.x
    for i = 2, #hand do
        if hand[i].T.x < x then
            x = hand[i].T.x
            dup = hand[i]
        end
    end
    local clone = Card(0, 0, 0, 0, dup.config.card, dup.config.center, {
        playing_card = dup.playing_card
    })
    table.insert(hand, 1, clone)
    local ret = raw_evaluate_poker_hand(hand)
    assert(table.remove(hand, 1) == clone)
    local ret2 = {}
    for k, v in pairs(ret) do
        ret2[k] = {}
        for k2, v2 in pairs(v) do
            if v2 ~= clone then
                ret2[k][k2] = v2
            end
        end
    end
    Bakery_API.no_update_joker_display = true
    clone:remove()
    Bakery_API.no_update_joker_display = false
    return ret2
end

local raw_five_of_a_kind_modify_display_text = SMODS.PokerHands['Five of a Kind'].modify_display_text
SMODS.PokerHand:take_ownership("Five of a Kind", {
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #scoring_hand >= 5 then
            return "Bakery_SixOfAKind"
        end
        if raw_five_of_a_kind_modify_display_text then
            return raw_five_of_a_kind_modify_display_text()
        end
    end
})

local raw_flush_five_modify_display_text = SMODS.PokerHands['Flush Five'].modify_display_text
SMODS.PokerHand:take_ownership("Flush Five", {
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #scoring_hand >= 5 then
            return "Bakery_FlushSix"
        end
        if raw_flush_five_modify_display_text then
            return raw_flush_five_modify_display_text()
        end
    end
})

local raw_two_pair_modify_display_text = SMODS.PokerHands['Two Pair'].modify_display_text
SMODS.PokerHand:take_ownership("Two Pair", {
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #scoring_hand == 5 and
            #get_X_same(2, scoring_hand, true) >= 2 then
            return "Bakery_ThreePair"
        end
        if raw_two_pair_modify_display_text then
            return raw_two_pair_modify_display_text()
        end
    end
})

local raw_flush_house_modify_display_text = SMODS.PokerHands['Flush House'].modify_display_text
SMODS.PokerHand:take_ownership("Flush House", {
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #scoring_hand == 5 then
            local dup = scoring_hand[1]
            local x = scoring_hand[1].T.x
            for i = 2, #scoring_hand do
                if scoring_hand[i].T.x < x then
                    x = scoring_hand[i].T.x
                    dup = scoring_hand[i]
                end
            end
            if next(get_X_same(4, scoring_hand, true)) then
                return "Bakery_FlushMansion"
            end
            local _3 = SMODS.merge_lists(get_X_same(3, scoring_hand, true))
            for _, v in ipairs(_3) do
                if v == dup then
                    return "Bakery_FlushMansion"
                end
            end
            if next(_3) then
                local _2 = SMODS.merge_lists(get_X_same(2, scoring_hand, true))
                for _, v in ipairs(_2) do
                    if v == dup then
                        return "Bakery_FlushTriplets"
                    end
                end
            end
        end
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Pedigree' and #all_suits(3, scoring_hand) >= 1 and
            #all_suits(2, scoring_hand) >= 2 and #get_X_same(3, scoring_hand, true) >= 1 and
            #get_X_same(2, scoring_hand, true) >= 2 then
            return "Bakery_StuffedFlush"
        end
        if raw_flush_house_modify_display_text then
            return raw_flush_house_modify_display_text()
        end
    end
})

local raw_flush_modify_display_text = SMODS.PokerHands['Flush'].modify_display_text
SMODS.PokerHand:take_ownership("Flush", {
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #scoring_hand == 5 and
            #get_X_same(2, scoring_hand, true) >= 2 then
            return "Bakery_FlushThreePair"
        end
        if raw_flush_modify_display_text then
            return raw_flush_modify_display_text()
        end
    end
})

Bakery_API.credit(Bakery_API.Charm {
    key = "AnaglyphLens",
    pos = {
        x = 1,
        y = 0
    },
    atlas = 'Charms',
    artist = "SadCube",
    unlocked = false,
    locked_loc_vars = function(info_queue, card)
        return {
            vars = { 9, G.P_TAGS.tag_double.discovered and localize("b_Bakery_double_tags") or localize('k_unknown') }
        }
    end,
    check_for_unlock = function(self, args)
        local count = 0
        for _, v in ipairs(G.GAME.tags) do
            if v.key == 'tag_double' then
                count = count + 1
            end
        end
        return count >= 9
    end
})

-- KEEP_LITE
Bakery_API.guard(function()
    function Bakery_API.maximus_full_house_compat(parts, val)
        return val
    end
end)
-- END_KEEP_LITE
function Bakery_API.maximus_full_house_compat(parts, val)
    if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Pedigree' and #parts.Bakery_s_3 >= 1 and #parts.Bakery_s_2 >= 2 and #parts.Bakery_s_all_pairs[1] >= 5 then
        val = { SMODS.merge_lists(val, parts.Bakery_s_all_pairs) }
    end
    return val
end

local raw_Full_House_evaluate = SMODS.PokerHands['Full House'].evaluate
local raw_Full_House_modify_display_text = SMODS.PokerHands['Full House'].modify_display_text
SMODS.PokerHand:take_ownership("Full House", {
    evaluate = function(parts)
        local val = raw_Full_House_evaluate(parts)
        return Bakery_API.maximus_full_house_compat(parts, val)
    end,
    modify_display_text = function(cards, scoring_hand)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Pedigree' and #all_suits(3, scoring_hand) >= 1 and
            #all_suits(2, scoring_hand) >= 2 and #get_X_same(3, scoring_hand, true) >= 1 and
            #get_X_same(2, scoring_hand, true) >= 2 then
            return "Bakery_StuffedHouse"
        end
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_AnaglyphLens' and #get_X_same(3, scoring_hand, true) >= 1 and
            #get_X_same(2, scoring_hand, true) >= 2 then
            return "Bakery_TwoTriplets"
        end
        if raw_Full_House_modify_display_text then
            return raw_Full_House_modify_display_text()
        end
    end
})

Bakery_API.Charm {
    key = "Pedigree",
    pos = {
        x = 2,
        y = 0
    },
    atlas = 'Charms'
}

local raw_G_FUNCS_can_discard = G.FUNCS.can_discard
function G.FUNCS.can_discard(e)
    if G.GAME.current_round.discards_left > 0 and #G.hand.highlighted <= 0 and
        (G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Rune' or G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Obsession') then
        e.config.colour = G.C.RED
        e.config.button = 'Bakery_discard_zero'
    else
        raw_G_FUNCS_can_discard(e)
    end
end

sendInfoMessage("G.FUNCS.can_discard() patched. Reason: Discarding zero cards", "Bakery")

G.FUNCS.Bakery_discard_zero = function(e)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then
        G.card_area_focus_reset = {
            area = G.hand,
            rank = G.CONTROLLER.focused.target.rank
        }
    end

    SMODS.calculate_context({
        pre_discard = true,
        full_hand = G.hand.highlighted
    })

    if G.GAME.Bakery_charm then
        juice_card(G.Bakery_charm_area.cards[1])
    end
    if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Rune' then
        local count = G.Bakery_charm_area.cards[1].ability.extra.cards
        for i = 1, count do
            draw_card(G.deck, G.hand, i * 100 / count, 'up', true)
        end
    elseif G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Obsession' then
        ease_dollars(G.Bakery_charm_area.cards[1].ability.extra.money)
    end

    if G.GAME.modifiers.discard_cost then
        ease_dollars(-G.GAME.modifiers.discard_cost)
    end
    ease_discard(-1)
    G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
    G.STATE = G.STATES.DRAW_TO_HAND
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if G.SCORING_COROUTINE then
                return false
            end
            G.STATE_COMPLETE = false
            return true
        end
    }))
end

Bakery_API.Charm {
    key = "Epitaph",
    pos = {
        x = 3,
        y = 0
    },
    atlas = 'Charms',
    unlocked = false,
    config = {
        extra = {
            xmult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == 'unscored' then
            juice_card(card)
            return {
                x_mult = card.ability.extra.xmult,
                card = context.other_card
            }
        end
    end,
    check_for_unlock = function(self, args)
        if args.type ~= 'modify_deck' or not G.playing_cards or #G.playing_cards == 0 then
            return
        end
        for _, v in pairs(G.playing_cards) do
            if not SMODS.always_scores(v) then
                return
            end
        end
        return true
    end
}

Bakery_API.credit(Bakery_API.Charm {
    key = "Rune",
    pos = {
        x = 4,
        y = 0
    },
    atlas = 'Charms',
    artist = 'GhostSalt',
    unlocked = false,
    config = {
        extra = {
            cards = 2
        }
    },
    locked_loc_vars = function(info_queue, card)
        return {
            vars = { 26 }
        }
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.cards }
        }
    end,
    check_for_unlock = function(self, args)
        return G.hand and #G.hand.cards >= 26
    end
})

local juicing = false
local raw_Game_update_draw_to_hand = Game.update_draw_to_hand
function Game:update_draw_to_hand(dt)
    local function condition()
        juicing = (G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Obsession' or G.GAME.Bakery_charm ==
                'BakeryCharm_Bakery_Rune') and G.GAME.current_round and G.GAME.current_round.discards_left > 0 and
            G.STATE ~= G.STATES.ROUND_EVAL
        return juicing
    end
    if not juicing and condition() then
        juice_card_until(G.Bakery_charm_area.cards[1], condition, true)
    end
    raw_Game_update_draw_to_hand(self, dt)
end

sendInfoMessage("Game:update_draw_to_hand() patched. Reason: Discard zero Charms juice")

Bakery_API.Charm {
    key = "Obsession",
    pos = {
        x = 0,
        y = 1
    },
    atlas = 'Charms',
    unlocked = false,
    config = {
        extra = {
            money = 4
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.money }
        }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win' and G.GAME.round_scores.cards_discarded.amt == 0
    end
}

Bakery_API.credit(Bakery_API.Charm {
    key = "Introversion",
    pos = {
        x = 1,
        y = 1
    },
    atlas = 'Charms',
    artist = 'GhostSalt',
    config = {
        extra = {}
    },
    equip = function(self, card)
        card.ability.extra.prior = G.GAME.joker_rate
        G.GAME.joker_rate = 0
    end,
    unequip = function(self, card)
        G.GAME.joker_rate = card.ability.extra.prior
    end
})

Bakery_API.credit(Bakery_API.Charm {
    key = "Extroversion",
    pos = {
        x = 2,
        y = 1
    },
    atlas = 'Charms',
    artist = 'GhostSalt',
    config = {
        extra = {}
    },
    equip = function(self, card)
        card.ability.extra.prior_t = G.GAME.tarot_rate
        card.ability.extra.prior_p = G.GAME.planet_rate
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
    end,
    unequip = function(self, card)
        G.GAME.tarot_rate = card.ability.extra.prior_t
        G.GAME.planet_rate = card.ability.extra.prior_p
    end
})

Bakery_API.Charm {
    key = "Coin",
    pos = {
        x = 3,
        y = 1
    },
    atlas = 'Charms',
    config = {
        extra = {
            mod = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mod }
        }
    end
}

local raw_e_negative_get_weight = G.P_CENTERS.e_negative.get_weight
SMODS.Edition:take_ownership('negative', {
    get_weight = function(self)
        local w = raw_e_negative_get_weight(self)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Void' then
            w = w * G.Bakery_charm_area.cards[1].ability.extra.mod
        end
        return w
    end
}, true)

Bakery_API.Charm {
    key = "Void",
    pos = {
        x = 4,
        y = 1
    },
    atlas = 'Charms',
    unlocked = false,
    config = {
        extra = {
            mod = 8
        }
    },
    locked_loc_vars = function(info_queue, card)
        return {
            vars = { 10 }
        }
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mod }
        }
    end,
    check_for_unlock = function(self, args)
        if args.type ~= 'modify_jokers' or not G.jokers then
            return
        end
        return #G.jokers.cards >= 10
    end
}
