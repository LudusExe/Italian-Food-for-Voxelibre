local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

mcl_structures.register_structure("pizzeria",{
	place_on = {"group:grass_block","group:dirt","mcl_core:dirt_with_grass"},
	fill_ratio = 0.01,
	flags = "place_center_x, place_center_z",
	solid_ground = true,
	make_foundation = true,
	chunk_probability = 600,
	y_max = mcl_vars.mg_overworld_max,
	y_min = 1,
	biomes = { "BirchForest", "Forest", "Plains" },
	sidelen = 16,
	y_offset = 0,
	filenames = {
		modpath.."/schematics/pizzeria.mts",
	},
	loot = {
		["mcl_barrels:barrel_closed" ] ={{
			stacks_min = 2,
			stacks_max = 4,
			items = {
				{ itemstring = "italian_food:pizza", weight = 16, amount_min = 3, amount_max=7 },
				{ itemstring = "italian_food:tomato", weight = 16, amount_min = 3, amount_max=7 },
				{ itemstring = "italian_food:basil", weight = 16, amount_min = 3, amount_max=7 },
				{ itemstring = "italian_food:pork_jowl", weight = 16, amount_min = 3, amount_max=7 },
				{ itemstring = "italian_food:sheep_milk_bucket", weight = 3, amount_min = 2, amount_max = 7 },
				{ itemstring = "mcl_core:iron_ingot", weight = 5, amount_min = 1, amount_max = 5 },
				{ itemstring = "mcl_core:diamond", weight = 1, amount_min = 1, amount_max = 3 },                      -- maybe more food is gonna be added 
				{ itemstring = "mcl_tools:axe_stone", weight = 15, },
				{ itemstring = "mcl_tools:sword_stone", weight = 15, },
				{ itemstring = "italian_food:rolling_pin", weight = 15, },
				{ itemstring = "mcl_tools:axe_iron", weight = 15, },
				{ itemstring = "mcl_torches:torch", weight = 15, amount_min = 3, amount_max=7 },
			}
		}}
	}
})