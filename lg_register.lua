local R = mcl_levelgen.build_random_spread_placement
local structure_biome_test = mcl_levelgen.structure_biome_test
local make_schematic_piece = mcl_levelgen.make_schematic_piece
local create_structure_start = mcl_levelgen.create_structure_start
local notify_generated = mcl_levelgen.notify_generated
local level_to_minetest_position = mcl_levelgen.level_to_minetest_position
local register_portable_schematic = mcl_levelgen.register_portable_schematic

if not mcl_levelgen.is_levelgen_environment then
	local modname = core.get_current_modname()
	local modpath = core.get_modpath(modname)

	register_portable_schematic(
		"italian_food:pizzeria",
		modpath .. "/schematics/italian_food_pizzeria.mts",
		true
	)

	mcl_levelgen.register_loot_table("italian_food:pizzeria_loot", {
		{
			stacks_min = 2,
			stacks_max = 6,
			items = {
				{ itemstring = "italian_food:pizza", weight = 15, amount_min = 1, amount_max = 4 },
				{ itemstring = "italian_food:tomato", weight = 15, amount_min = 3, amount_max = 5 },
				{ itemstring = "italian_food:basil", weight = 15, amount_min = 3, amount_max = 14 },
				{ itemstring = "italian_food:pork_jowl", weight = 14, amount_min = 2, amount_max = 3 },
				{ itemstring = "italian_food:sheep_milk_bucket", weight = 3, amount_min = 1, amount_max = 2 },
				{ itemstring = "mcl_core:iron_ingot", weight = 5, amount_min = 1, amount_max = 5 },
				{ itemstring = "mcl_jukebox:record_tarantella", weight = 1, amount_min = 1, amount_max = 1 },
				{ itemstring = "italian_food:coffee_bean", weight = 10 },
				{ itemstring = "italian_food:rolling_pin", weight = 10 },
				{ itemstring = "mcl_tools:axe_iron", weight = 10 },
				{ itemstring = "mcl_torches:torch", weight = 10, amount_min = 3, amount_max = 8 },
			}
		},
	})
end

------------------------------------------------------------------------
-- Pizzeria.
------------------------------------------------------------------------

local function getcid(name)
	if mcl_levelgen.is_levelgen_environment then
		return core.get_content_id(name)
	else
		-- Content IDs are unnecessary in non-mapgen environments, as in such environments structure generators will only be invoked to locate structures.
		return 0
	end
end

local cid_barrel_closed = getcid("mcl_barrels:barrel_closed")
local mathabs = math.abs
local set_loot_table = mcl_levelgen.set_loot_table

local function pizzeria_loot(x, y, z, rng, cid_existing,
	param2_existing, cid, param2)
	if cid == cid_barrel_closed then
		set_loot_table(x, y, z, rng, "italian_food:pizzeria_loot")
	end
	return cid, param2
end

local index_biome = mcl_levelgen.index_biome
local cid_grass_block = getcid("mcl_core:dirt_with_grass")
local registered_biomes = mcl_levelgen.registered_biomes

local function set_grass_palette(x, y, z, rng, cid_existing,
	param2_existing, cid, param2)
	if cid == cid_grass_block then
		local biome = index_biome(x, y, z)
		local def = registered_biomes[biome]
		return cid, def.grass_palette_index
	end
	return cid, param2
end

local pizzeria_processors = {
	pizzeria_loot,
	set_grass_palette,
}

local function pizzeria_create_start(self, level, terrain, rng, cx, cz)
	local schematic = "italian_food:pizzeria"
	local x = cx * 16 + rng:next_within(16)
	local z = cz * 16 + rng:next_within(16)
	local y = terrain:get_one_height(x, z)

	if y < level.preset.sea_level then
		return nil
	elseif structure_biome_test(level, self, x, y, z) then
		local pieces = {
			make_schematic_piece(
				schematic,
				x, y, z,
				"random",
				rng,
				true,
				true,
				pizzeria_processors,
				nil,
				nil
			),
		}
		return create_structure_start(self, pieces)
	end

	return nil
end

------------------------------------------------------------------------
-- Pizzeria registration.
------------------------------------------------------------------------

local pizzeria_biomes = {
	"BirchForest",
	"Forest",
	"Plains",
}

mcl_levelgen.modify_biome_groups(pizzeria_biomes, {
	["italian_food:has_pizzeria"] = true,
})

mcl_levelgen.register_structure("italian_food:pizzeria", {
	create_start = pizzeria_create_start,
	step = mcl_levelgen.SURFACE_STRUCTURES,
	terrain_adaptation = "beard_box",
	biomes = mcl_levelgen.build_biome_list({
		"#italian_food:has_pizzeria",
	}),
})

mcl_levelgen.register_structure_set("italian_food:pizzerias", {
	structures = {
		"italian_food:pizzeria",
	},
	placement = R(
		0.8,
		"default",
		80,
		20,
		651903593,
		"linear",
		nil,
		nil
	),
})
