--- STEAMODDED HEADER
--- MOD_NAME: Gerio Cards Part 2
--- MOD_ID: gerio_cards_part_2
--- PREFIX: gerioc2
--- MOD_AUTHOR: [GerioSB]
--- MOD_DESCRIPTION: An Second set of Gerio Cards. Usually Unbalanced. Requires Gerio Cards Part 1.
--- DEPENDENCIES: [gerio_cards_part_1]

----------------------------------------------
------------MOD CODE -------------------------

local sega_pattern = "TITIIJILSJOZZJLSJISLZZZJIJJJOLZJSILTLJOIOOTJTOSZZOISLZTOJJLSJOIIZZZJSIIZLZZOIOOTSZZSSSTJOZITZOSLLTZJJZZJJIZOSOJLOZLZJLJIIOTTOOIZSJSSSTLZLJTZOLLOOILTSZTTOILZOJISLTILLZTSLISTTIIJSSZTTLLILJZOOZTIISZTIJIJTSOLTTLIITIOLTSJILIOOJSOZZLZZLLSZJZOSZLLLZZJITZTSLOISOLLOSOOZLJSJOZJZISZSLLJITTISJZIIOOOOTJZZIOJOZOJJJSZJTJTJJSJSSSILOTLOITJISSZJIOOOZOISTSJLSTTSLLOSLZJSOLIJJLIZSTJISSSTTIJOJZJIOLLLIIOIZSLTOOLOOZJOJSSLJSTZTZJLZITZTSJLIZSZSTITJZTJOJIJSJJLTOOSZLIOSIJOIOOLSZJLSLJIZLSJIIJITSTLSISLZZOJZSSIOZTLZTJZIZSJTOTTLOTSTTJLILJSOOJOLTLOILTSIJIJTZJLZIITIOOLZLLTIIJTZTLSITLSSISTTTLILISLTLTTTITLTJTJLLSIITLZLTSZJZOISOSIOTSOJLJJSSZJOSOTOISLSTJLZSLZZSLISLJZTJLJSZZLSSSIIJTOJJSZLJLIZOIJSSJLSTSJOSJTOLLTTSTIJLZTOTZLSZLJTOLSSTTLTIOSTTILSJZTLILIZIOTTZSOJLILSJOOIJOZIJJISIOIIOIZZLOIITTZTTIZTLIILSITTOSZOTZSSTJZOJJLOOSJZJLOIJSTOZTZZTOZLOLOLJOZLOIISLJZIOZTTTZISOTOIIZZZLITSLTIZZISZSJTIOZLZOLOSJSLIJLILOJTZJOJLTOLSOLIZJJOZIILTITIZZJTSTSTITILTSTLOJZZOLZOZLJJJOTITLTSSZTOSTZSTOTJJLZSIIZZSISJSSSZIJIIOIOZOIZJTJIJOIISTTJJTTTJITTITSI"

SMODS.Atlas {
  -- Key for code to find it with
  key = "gerio_p2_geriolish_1",
  -- The name of the file, for the code to pull the atlas from
  path = "geriolish.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Joker {
	key = 'gerio_bamtris',
	loc_txt = {
		name = 'Bamtris',
		text = {
			"Produces a {C:attention}Negative{}",
			"{C:attention}Monomino{} every",
			"hand, destroys itself",
			"after #1# turns.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 0, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "j_gerioc2_gerio_monomino", set = "Joker", vars = {} }
		return { vars = { card.ability.extra.remain } }
	end,
	update = function(self, card, dt)
		card.ability.extra.remain = math.floor(card.ability.extra.remain+0.5) --for the case where the number isn't integer
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			if not (card.ability.eternal or card.ability.unbreakable) then
				card.ability.extra.remain = card.ability.extra.remain - 1
			end
				G.E_MANAGER:add_event(Event({
					func = function()
						card2 = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc2_gerio_monomino")
						card2:set_edition({negative = true}, true)
						card2:add_to_deck()
						G.jokers:emplace(card2)
						card2:start_materialize()
						return true
					end,
				}))
			if card.ability.extra.remain <= 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:start_dissolve()
						return true
					end,
				}))
				return {
					message = localize("k_extinct_ex")
				}
			else
				return {
					message = "create"
				}
			end
		end
	end,
}

SMODS.Joker {
	key = 'gerio_monomino',
	loc_txt = {
		name = 'Monomino',
		text = {
			"Monomino.",
			"What happens",
			"if you merge",
			"{C:attention}4{} of them?",
		}
	},
	config = { consumable = true, extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 8, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	update = function(self, card, dt)
		card.ability.consumable = true
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_i_tetrimino',
	loc_txt = {
		name = 'I Tetrimino',
		text = {
			"Straightforward,",
			"{X:mult,C:white}x#1#{} mult if",
			"the hand is",
			"{C:attention}#2#{},",
			"{C:attention}#3#{},",
			"{C:attention}#4#{},",
			"{C:attention}#5#{},",
			"{C:attention}#6#{} or",
			"{C:attention}#7#{}.",
		}
	},
	config = { extra = { mult = 6 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 1, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				localize("Flush Five", "poker_hands"),
				localize("Five of a Kind", "poker_hands"),
				localize("Straight Flush", "poker_hands"),
				localize("Four of a Kind", "poker_hands"),
				localize("Flush", "poker_hands"),
				localize("Straight", "poker_hands"),
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_l_tetrimino',
	loc_txt = {
		name = 'L Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 2, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_o_tetrimino',
	loc_txt = {
		name = 'O Tetrimino',
		text = {
			"Box.",
			"Produces a {C:attention}Negative{}",
			"{C:attention}Square Joker{} every",
			"hand, destroys itself",
			"after #1# turns.",
		}
	},
	config = { extra = { remain = 4 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 3, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "j_square", set = "Joker", vars = {} }
		return { vars = { card.ability.extra.remain } }
	end,
	update = function(self, card, dt)
		card.ability.extra.remain = math.floor(card.ability.extra.remain+0.5) --for the case where the number isn't integer
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			if not (card.ability.eternal or card.ability.unbreakable) then
				card.ability.extra.remain = card.ability.extra.remain - 1
			end
				G.E_MANAGER:add_event(Event({
					func = function()
						card2 = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_square")
						card2:set_edition({negative = true}, true)
						card2:add_to_deck()
						G.jokers:emplace(card2)
						card2:start_materialize()
						return true
					end,
				}))
			if card.ability.extra.remain <= 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:start_dissolve()
						return true
					end,
				}))
				return {
					message = localize("k_extinct_ex")
				}
			else
				return {
					message = "create"
				}
			end
		end
	end,
}

SMODS.Joker {
	key = 'gerio_z_tetrimino',
	loc_txt = {
		name = 'Z Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 4, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_t_tetrimino',
	loc_txt = {
		name = 'T Tetrimino',
		text = {
			"Full of Twists.",
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 5, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_j_tetrimino',
	loc_txt = {
		name = 'J Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 6, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

SMODS.Joker {
	key = 'gerio_s_tetrimino',
	loc_txt = {
		name = 'S Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerio_p2_geriolish_1',
	pos = { x = 7, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.remain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize("k_extinct_ex")
			}
		end
	end,
}

----------------------------------------------
------------MOD CODE END----------------------