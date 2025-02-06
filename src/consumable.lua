SMODS.Atlas {
    key = "BakeryConsumables",
    path = "BakeryConsumables.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'Astrology',
    set = 'Spectral',
    atlas = "BakeryConsumables",
    pos = {
        x = 0,
        y = 0
    },
    cost = 5,
    hidden = true,
    soul_set = 'Planet',
    soul_rate = 0.003,
    config = {
        extra = {
            multiplier = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.multiplier}
        }
    end,
    use = function(self, card, area, copier)
        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 0.8,
            delay = 0.3
        }, {
            handname = localize('k_all_hands'),
            chips = '...',
            mult = '...',
            level = ''
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        update_hand_text({
            delay = 0
        }, {
            mult = '=',
            StatusText = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({
            delay = 0
        }, {
            chips = '=',
            StatusText = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 0.9,
            delay = 0
        }, {
            level = '1'
        })
        delay(1.3)

        local levels = 0
        for k, v in pairs(G.GAME.hands) do
            levels = levels + math.max(v.level - 1, 0)
            v.level = 1
            v.mult = math.max(v.s_mult + v.l_mult * (v.level - 1), 1)
            v.chips = math.max(v.s_chips + v.l_chips * (v.level - 1), 0)
        end

        ease_dollars(levels * card.ability.extra.multiplier)

        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 1.1,
            delay = 0
        }, {
            mult = 0,
            chips = 0,
            handname = '',
            level = ''
        })
    end,
    can_use = function(self, card)
        for k, v in pairs(G.GAME.hands) do
            if v.level > 1 then
                return true
            end
        end
        return false
    end
}

SMODS.Consumable {
    key = 'TimeMachine',
    set = 'Spectral',
    atlas = "BakeryConsumables",
    pos = {
        x = 1,
        y = 0
    },
    cost = 7,
    config = {
        mod_conv = 'm_Bakery_TimeWalk',
        max_highlighted = 1
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_Bakery_TimeWalk
        return {
            vars = {self.config.max_highlighted, localize {
                type = 'name_text',
                set = 'Enhanced',
                key = self.config.mod_conv
            }}
        }
    end
}
