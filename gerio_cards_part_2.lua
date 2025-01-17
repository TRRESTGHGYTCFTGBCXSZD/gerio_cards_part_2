

----------------------------------------------
------------MOD CODE -------------------------

local sega_pattern = "TITIIJILSJOZZJLSJISLZZZJIJJJOLZJSILTLJOIOOTJTOSZZOISLZTOJJLSJOIIZZZJSIIZLZZOIOOTSZZSSSTJOZITZOSLLTZJJZZJJIZOSOJLOZLZJLJIIOTTOOIZSJSSSTLZLJTZOLLOOILTSZTTOILZOJISLTILLZTSLISTTIIJSSZTTLLILJZOOZTIISZTIJIJTSOLTTLIITIOLTSJILIOOJSOZZLZZLLSZJZOSZLLLZZJITZTSLOISOLLOSOOZLJSJOZJZISZSLLJITTISJZIIOOOOTJZZIOJOZOJJJSZJTJTJJSJSSSILOTLOITJISSZJIOOOZOISTSJLSTTSLLOSLZJSOLIJJLIZSTJISSSTTIJOJZJIOLLLIIOIZSLTOOLOOZJOJSSLJSTZTZJLZITZTSJLIZSZSTITJZTJOJIJSJJLTOOSZLIOSIJOIOOLSZJLSLJIZLSJIIJITSTLSISLZZOJZSSIOZTLZTJZIZSJTOTTLOTSTTJLILJSOOJOLTLOILTSIJIJTZJLZIITIOOLZLLTIIJTZTLSITLSSISTTTLILISLTLTTTITLTJTJLLSIITLZLTSZJZOISOSIOTSOJLJJSSZJOSOTOISLSTJLZSLZZSLISLJZTJLJSZZLSSSIIJTOJJSZLJLIZOIJSSJLSTSJOSJTOLLTTSTIJLZTOTZLSZLJTOLSSTTLTIOSTTILSJZTLILIZIOTTZSOJLILSJOOIJOZIJJISIOIIOIZZLOIITTZTTIZTLIILSITTOSZOTZSSTJZOJJLOOSJZJLOIJSTOZTZZTOZLOLOLJOZLOIISLJZIOZTTTZISOTOIIZZZLITSLTIZZISZSJTIOZLZOLOSJSLIJLILOJTZJOJLTOLSOLIZJJOZIILTITIZZJTSTSTITILTSTLOJZZOLZOZLJJJOTITLTSSZTOSTZSTOTJJLZSIIZZSISJSSSZIJIIOIOZOIZJTJIJOIISTTJJTTTJITTITSI"

SMODS.Atlas {
  -- Key for code to find it with
  key = "geriolish_1",
  -- The name of the file, for the code to pull the atlas from
  path = "geriolish.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

local bamtris_variants = {
	{"looking","gerioc2_geriolish_1",{x=9,y=0}},
	{"weirdo","gerioc2_geriolish_1",{x=0,y=1}},
	{"gerio","gerioc2_geriolish_1",{x=1,y=1}},
	{"bodyless","gerioc2_geriolish_1",{x=2,y=1}},
	{"old","gerioc2_geriolish_1",{x=3,y=1}},
	{"different","gerioc2_geriolish_1",{x=4,y=1}},
	{"budget","gerioc2_geriolish_1",{x=5,y=1}},
}

SMODS.Joker {
	key = 'bamtris',
	loc_txt = {
		name = 'Bamtris',
		text = {
			"Produces a {C:attention}Negative{}",
			"{C:attention}#2#{} every",
			"hand, destroys itself",
			"after #1# turns.",
		}
	},
	config = { extra = { remain = 8, variant = nil } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
	pos = { x = 0, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	add_to_deck = function(self, card, from_debuff)
		math.randomseed(os.time())
		if (not from_debuff) and (not card.ability.extra.variant) and math.random() >= 3/5 then
			card.ability.extra.variant = tostring(math.random(1,#bamtris_variants))
		else
			card.ability.extra.variant = "0"
		end
		if card.ability.extra.kado then
			if card.ability.extra.kado ~= card then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card:start_dissolve()
						return true
					end,
				}))
				return {
					message = "No-Cloning theorem!"
				}
			end
		else
			card.ability.extra.kado = card
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "j_gerioc2_monomino", set = "Joker", vars = {} }
		if card.ability.extra.variant and bamtris_variants[tonumber(card.ability.extra.variant)] then
			info_queue[#info_queue + 1] = { key = "Bamtris_Variant_"..bamtris_variants[tonumber(card.ability.extra.variant)][1], set = "Other", vars = {} }
		end
		return { vars = { card.ability.extra.remain, localize{type="name_text", key = "j_gerioc2_monomino", set = "Joker"} } }
	end,
	update = function(self, card, dt)
		if card.ability.extra.variant and bamtris_variants[tonumber(card.ability.extra.variant)] then
			card.children.center.atlas = G.ASSET_ATLAS[bamtris_variants[tonumber(card.ability.extra.variant)][2]]
			card.children.center:set_sprite_pos(bamtris_variants[tonumber(card.ability.extra.variant)][3])
		end
		card.ability.extra.remain = math.floor(card.ability.extra.remain+0.5) --for the case where the number isn't integer
	end,
	load = function(self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event({
			func = function()
				card.ability.extra.kado = card -- no-cloning theorem fix
				return true
			end,
		}))
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			if card.ability.extra.kado ~= card then
				if card.ability.gerio_unbreakable then
					card.ability.gerio_unbreakable = "bypass"
				end
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card:start_dissolve()
						return true
					end,
				}))
				return {
					message = "No-Cloning theorem!"
				}
			else
				if not card.ability.extra.kado then
					card.ability.extra.kado = card
				end
				if not (card.ability.eternal or card.ability.gerio_unbreakable) then
					card.ability.extra.remain = card.ability.extra.remain - 1
				end
					G.E_MANAGER:add_event(Event({
						func = function()
							card2 = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc2_monomino")
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
							play_sound("tarot1")
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
		end
	end,
}

local geriotetrapieces = {
	"j_gerioc2_i_tetrimino",
	"j_gerioc2_l_tetrimino",
	"j_gerioc2_o_tetrimino",
	"j_gerioc2_z_tetrimino",
	"j_gerioc2_t_tetrimino",
	"j_gerioc2_j_tetrimino",
	"j_gerioc2_s_tetrimino",
}

function iscard(card,cardkey)
	return card.config.center == G.P_CENTERS[cardkey]
end

function iscardlist(card,cardkeylist)
	for _,h in pairs(cardkeylist) do
		if iscard(card,h) then
			return true
		end
	end
	return false
end

SMODS.Joker {
	key = 'monomino',
	loc_txt = {
		name = 'Monomino',
		text = {
			"Monomino.",
			"What happens",
			"if you merge",
			"{C:attention}4{} of them?",
			"{C:inactive}(auto-merges){}",
		}
	},
	config = { extra = { marked_for_removal = false } }, -- i give up
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
	pos = { x = 8, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.joker_main and (not context.blueprint) and (not card.ability.extra.marked_for_removal) then
			local monominos = {}
			for _,h in pairs(card.area.cards) do
				if iscard(h,"j_gerioc2_monomino") and h ~= card and (not h.ability.extra.marked_for_removal) then
					monominos[#monominos+1]=h
				end
			end
			if #monominos+1 >= 4 then
				card.ability.extra.marked_for_removal = true
				monominos[1].ability.extra.marked_for_removal = true
				monominos[2].ability.extra.marked_for_removal = true
				monominos[3].ability.extra.marked_for_removal = true
				if not G.GAME.total_piece_spawned then
					G.GAME.total_piece_spawned = 0
				end
				G.GAME.total_piece_spawned = G.GAME.total_piece_spawned + 1
				local piece_output
				if G.GAME.pseudorandom.seed == "2A6D365A" then
					local yoyoyo = math.fmod(G.GAME.total_piece_spawned-1,1000)+1
					piece_output = "j_gerioc2_"..string.lower(string.sub(sega_pattern,yoyoyo,yoyoyo)).."_tetrimino"
				else
					piece_output = geriotetrapieces[math.fmod(math.floor(pseudorandom("geriotetrapieces")*7),7)+1]
				end
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card2 = create_card('Joker', G.jokers,nil,nil,nil,nil, piece_output)
						card2:add_to_deck()
						G.jokers:emplace(card2)
						card2:start_materialize()
						card:start_dissolve()
						monominos[1]:start_dissolve()
						monominos[2]:start_dissolve()
						monominos[3]:start_dissolve()
						return true
					end,
				}))
			end
		end
	end,
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 'i_tetrimino',
	loc_txt = {
		name = 'I Tetrimino',
		text = {
			"Straightforward.",
			"{X:mult,C:white}x#1#{} mult if",
			"your hand contains",
			"{C:attention}#2#{},",
			"{C:attention}#3#{} or",
			"{C:attention}#4#{}.",
		}
	},
	config = { extra = { t_mult = 6 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
	pos = { x = 1, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.t_mult,
				localize("Four of a Kind", "poker_hands"),
				localize("Flush", "poker_hands"),
				localize("Straight", "poker_hands"),
			}
		}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and not context.before and not context.after and context.poker_hands and 
		(next(context.poker_hands["Four of a Kind"]) or 
		next(context.poker_hands["Flush"]) or 
		next(context.poker_hands["Straight"]))
		then
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.t_mult } }),
				colour = G.C.RED,
				Xmult_mod = card.ability.extra.t_mult,
			}
		end
	end,
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 'l_tetrimino',
	loc_txt = {
		name = 'L Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
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
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 'o_tetrimino',
	loc_txt = {
		name = 'O Tetrimino',
		text = {
			"Box.",
			"{C:mult}+#1#{} mult every",
			"{C:attention}tetriminos{}",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
		}
	},
	config = { extra = { t_mult = 1 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
	pos = { x = 3, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		local tetriminos = {}
		for _,h in pairs(card.area.cards) do
			if iscardlist(h,geriotetrapieces) and h ~= card then
				tetriminos[#tetriminos+1]=h
			end
		end
		return { vars = { card.ability.extra.t_mult, #tetriminos*card.ability.extra.t_mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local tetriminos = {}
			for _,h in pairs(card.area.cards) do
				if iscardlist(h,geriotetrapieces) and h ~= card then
					tetriminos[#tetriminos+1]=h
				end
			end
			return {
				message = localize({ type = "variable", key = "a_mult", vars = { #tetriminos*card.ability.extra.t_mult } }),
				colour = G.C.RED,
				mult_mod = #tetriminos*card.ability.extra.t_mult,
			}
		end
	end,
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 'z_tetrimino',
	loc_txt = {
		name = 'Z Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
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
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 't_tetrimino',
	loc_txt = {
		name = 'T Tetrimino',
		text = {
			"Full of Twists.",
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
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
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 'j_tetrimino',
	loc_txt = {
		name = 'J Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
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
	in_pool = function(self)
		return false
	end,
}

SMODS.Joker {
	key = 's_tetrimino',
	loc_txt = {
		name = 'S Tetrimino',
		text = {
			"Does nothing for the moment.",
		}
	},
	config = { extra = { remain = 8 } },
	rarity = 3,
	atlas = 'gerioc2_geriolish_1',
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
	in_pool = function(self)
		return false
	end,
}

SMODS.Consumable {
	key = 'tetra_blocker',
	set = 'Spectral',
	loc_txt = {
		name = 'Blocker',
		text = {
		"Use this card to",
		"get #2# #1#",
		"to your deck",
		}
	},
	config = { extra = { blocks = 200 } },
		loc_vars = function(self, info_queue, card)
			info_queue[#info_queue + 1] = { key = "j_gerioc2_monomino", set = "Joker", vars = {} }
			return { vars = { localize{type="name_text", key = "j_gerioc2_monomino", set = "Joker"}, card.ability.extra.blocks } }
		end,
	rarity = 4,
	--atlas = 'gerioc2_geriolish_1',
	set_sprites = function(self, card, front)
		card.children.center.atlas = G.ASSET_ATLAS["gerioc1_geriolish_1"]
		card.children.center:set_sprite_pos(self.pos)
	end,
	pos = { x = 0, y = 1 },
	cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _ = 1,card.ability.extra.blocks do
					local card2 = create_card('Jokers', G.jokers,nil,nil,nil,nil, "j_gerioc2_monomino")
					card2:set_edition({negative = true}, true)
					card2:add_to_deck()
					G.jokers:emplace(card2)
					card2:start_materialize()
				end
				return true
			end
		}))
		return true
	end,
	can_use = function(self, card)
		return true
	end,
}

SMODS.Consumable {
	key = 'woot_bamtris',
	set = 'Spectral',
	loc_txt = {
		name = 'Quad Formation',
		text = {
		"Converse Card",
		"To Bamtris",
		}
	},
	config = { mod_conv = "j_gerioc2_bamtris", max_highlighted = math.huge },
	rarity = 4,
	atlas = 'gerioc2_geriolish_1',
	pos = { x = 0, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
}
--[[
SMODS.Booster{ -- adaptive pack that adjusts how much this pack contains
	key = "all_arcana_pack",
	loc_txt = {
		name = "All Arcana Pack",
		group_name = "All Arcana", -- Pack group text while a pack is being opened, omit if using group_key
		text = {
			"Choose {C:attention}#1#{} of up to",
			"{C:attention}#2#{C:tarot} Tarot{} cards to",
			"be used immediately",
		},
	},
	pos = { x = 0, y = 5 },
	config = { extra = 4, choose = 4 },
	draw_hand = true,
	discovered = true,
	weight = 100000,
	kind = "Tarot",
	update = function(self, card, dt)
		local kanto = 0
		for h,j in pairs(G.P_CENTERS) do
			if string.sub(h,1,1) == "c" and j.set == self.kind then
				kanto = kanto + 1
			end
		end
		self.config = { extra = kanto, choose = kanto }
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.choose, self.config.extra } }
	end,
}

SMODS.Booster{ -- adaptive pack that adjusts how much this pack contains
	key = "all_celestial_pack",
	loc_txt = {
		name = "Universal Pack",
		group_name = "All Celestial", -- Pack group text while a pack is being opened, omit if using group_key
		text = {
			"Choose {C:attention}#1#{} of up to",
			"{C:attention}#2#{C:planet} Planet{} cards to",
			"be used immediately",
		},
	},
	pos = { x = 0, y = 5 },
	config = { extra = 4, choose = 4 },
	draw_hand = false,
	discovered = true,
	weight = 100000,
	kind = "Planet",
	update = function(self, card, dt)
		local kanto = 0
		for h,j in pairs(G.P_CENTERS) do
			if string.sub(h,1,1) == "c" and j.set == self.kind then
				kanto = kanto + 1
			end
		end
		self.config = { extra = kanto, choose = kanto }
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.choose, self.config.extra } }
	end,
}

SMODS.Booster{ -- adaptive pack that adjusts how much this pack contains
	key = "all_spectral_pack",
	loc_txt = {
		name = "Ghostbusters Pack",
		group_name = "All Spectral", -- Pack group text while a pack is being opened, omit if using group_key
		text = {
			"Choose {C:attention}#1#{} of up to",
			"{C:attention}#2#{C:spectral} Spectral{} cards to",
			"be used immediately",
		},
	},
	pos = { x = 0, y = 5 },
	config = { extra = 4, choose = 4 },
	draw_hand = true,
	discovered = true,
	weight = 100000,
	kind = "Spectral",
	update = function(self, card, dt)
		local kanto = 0
		for h,j in pairs(G.P_CENTERS) do
			if string.sub(h,1,1) == "c" and j.set == self.kind then
				kanto = kanto + 1
			end
		end
		self.config = { extra = kanto, choose = kanto }
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.choose, self.config.extra } }
	end,
}
--]]

----------------------------------------------
------------MOD CODE END----------------------