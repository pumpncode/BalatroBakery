SMODS.Atlas {
    key = "BakeryEnhancements",
    path = "BakeryEnhancements.png",
    px = 71,
    py = 95
}

SMODS.Sound {
    key = "TimeWalk",
    path = "TimeWalk.ogg"
}

SMODS.Enhancement {
    key = "TimeWalk",
    atlas = 'BakeryEnhancements',
    pos = {
        x = 0,
        y = 0
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    weight = 0.1,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            if not (Talisman and Talisman.config_file and Talisman.config_file.disable_anims) then
                G.E_MANAGER:add_event(Event {
                    trigger = 'before',
                    delay = 1 * G.SETTINGS.GAMESPEED,
                    func = function()
                        play_sound("Bakery_TimeWalk", 0.8 + math.random() * 0.2, 1)
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event {
                    trigger = 'immediate',
                    func = function()
                        card:juice_up(0.6, 0.1)
                        return true
                    end
                })
            end -- Entirely visual
            ease_hands_played(1)
            delay(0.85)
            return {
                effect = true
            }
        end
    end
}
