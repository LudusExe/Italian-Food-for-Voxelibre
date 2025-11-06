biolib = {}

-- Debugging functions ---------------------------------------------------------

function biolib.__dump_obj(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- text is a string, that will be shown in global chat.
function biolib.debug(text)
	minetest.chat_send_all(text)
end

-- text is a string that will be shown in global chat.
-- object is an Object that will be either destructured, or its type printed
function biolib.debug_object(text, obj)
	local output = biolib.__dump_obj(obj)
	biolib.debug(text..output)
end

-- Compat functions ------------------------------------------------------------

-- compat function for check growth with, and make it compatible to games, that don't expose it
if mcl_core ~= nil and mcl_core.check_growth_width ~= nil then
	biolib.check_growth_width = mcl_core.check_growth_width
else
	biolib.check_growth_width = function (pos, width, height)
		-- Huge tree (with even width to check) will check one more node in
		-- positive x and y directions.
		local neg_space = math.min((width - 1) / 2)
		local pos_space = math.max((width - 1) / 2)
		for x = -neg_space, pos_space do
			for z = -neg_space, pos_space do
				for y = 1, height do
					local np = vector.new(
						pos.x + x,
						pos.y + y,
						pos.z + z)
					if biolib.node_stops_growth(minetest.get_node(np)) then
						return false
					end
				end
			end
		end
		return true
	end

	biolib.node_stops_growth = function (node)
		if node.name == "air" then
			return false
		end
	
		local def = minetest.registered_nodes[node.name]
		if not def then
			return true
		end
	
		local groups = def.groups
		if not groups then
			return true
		end
		if groups.plant or groups.torch or groups.dirt or groups.tree
			or groups.bark or groups.leaves or groups.wood then
			return false
		end
	
		return true
	end
end


-- Registry functions ----------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())
local on_rotate
if mod_screwdriver then
	on_rotate = screwdriver.rotate_3way
end

-- nodename is the name of the node to register as tree trunk
-- description_trunk is the translated name of teh Trunk
-- description_bark is the translated name of the Bark
-- longdesc is the long description for the tree trunk
-- tile_inner is the texture for the cut part
-- tile_bark is the texture for the bark part
-- stripped_variant is the node name for the stripped variant
function biolib.register_tree_trunk(nodename, description_trunk, description_bark, longdesc, tile_inner, tile_bark, stripped_variant)
	minetest.register_node(nodename, {
		description = description_trunk,
		_doc_items_longdesc = longdesc,
		_doc_items_hidden = false,
		tiles = {tile_inner, tile_inner, tile_bark},
		paramtype2 = "facedir",
		on_place = mcl_util.rotate_axis,
		stack_max = 64,
		groups = {handy=1,axey=1, tree=1, flammable=2, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
		sounds = mcl_sounds.node_sound_wood_defaults(),
		on_rotate = on_rotate,
		_mcl_blast_resistance = 2,
		_mcl_hardness = 2,
		_mcl_stripped_variant = stripped_variant,
		after_destruct = mcl_core.update_leaves,
	})

	minetest.register_node(nodename.."_bark", {
		description = description_bark,
		_doc_items_longdesc = S("This is a decorative block surrounded by the bark of a tree trunk."),
		tiles = {tile_bark},
		paramtype2 = "facedir",
		on_place = mcl_util.rotate_axis,
		stack_max = 64,
		groups = {handy=1,axey=1, bark=1, flammable=2, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
		sounds = mcl_sounds.node_sound_wood_defaults(),
		is_ground_content = false,
		on_rotate = on_rotate,
		_mcl_blast_resistance = 2,
		_mcl_hardness = 2,
		_mcl_stripped_variant = stripped_variant.."_bark",
	})

	minetest.register_craft({
		output = nodename.."_bark 3",
		recipe = {
			{ nodename, nodename },
			{ nodename, nodename },
		}
	})
end

-- nodename is the name of the node in question
-- description_stripped_trunk is the description of the stripped trunk variant
-- description_stripped_bark is the description of the stripped bark variant
-- longdesc is the long description for the stripped trunk
-- longdesc_wood is the long description for the stripped bark
-- tile_stripped_inner is the cut texture for the stripped wood
-- tile_stripped_bark is the side texture for the stripped wood
function biolib.register_stripped_trunk(nodename, description_stripped_trunk, description_stripped_bark, longdesc, longdesc_wood, tile_stripped_inner, tile_stripped_bark)
	minetest.register_node(nodename, {
		description = description_stripped_trunk,
		_doc_items_longdesc = longdesc,
		_doc_items_hidden = false,
		tiles = {tile_stripped_inner, tile_stripped_inner, tile_stripped_bark},
		paramtype2 = "facedir",
		on_place = mcl_util.rotate_axis,
		stack_max = 64,
		groups = {handy=1, axey=1, tree=1, flammable=2, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
		sounds = mcl_sounds.node_sound_wood_defaults(),
		on_rotate = on_rotate,
		_mcl_blast_resistance = 2,
		_mcl_hardness = 2,
	})

	minetest.register_node(nodename.."_bark", {
		description = description_stripped_bark,
		_doc_items_longdesc = longdesc_wood,
		tiles = {tile_stripped_bark},
		paramtype2 = "facedir",
		on_place = mcl_util.rotate_axis,
		stack_max = 64,
		groups = {handy=1, axey=1, bark=1, flammable=2, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
		sounds = mcl_sounds.node_sound_wood_defaults(),
		is_ground_content = false,
		on_rotate = on_rotate,
		_mcl_blast_resistance = 2,
		_mcl_hardness = 2,
	})

	minetest.register_craft({
		output = nodename.."_bark 3",
		recipe = {
			{ nodename, nodename },
			{ nodename, nodename },
		}
	})
end

-- nodename is the name of the node in question
-- description is the description of the planks
-- tiles is the texture for the planks
function biolib.register_planks(nodename, description, tiles)
	minetest.register_node(nodename, {
		description = description,
		_doc_items_longdesc = doc.sub.items.temp.build,
		_doc_items_hidden = false,
		tiles = tiles,
		stack_max = 64,
		is_ground_content = false,
		groups = {handy=1,axey=1, flammable=3,wood=1,building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
		sounds = mcl_sounds.node_sound_wood_defaults(),
		_mcl_blast_resistance = 3,
		_mcl_hardness = 2,
	})
end

-- name is the name of the node without the mod identifier
-- nodename is the name of the node in question (with mod)
-- texture is the texture, that shall be used for the stairs and slabs
-- stairs_name is the translated name for the stairs
-- slabs_name is the translated name for the single slab
-- dbl_slabs_name is the translated name for double slabs
function biolib.register_wooden_stairs(name, nodename, texture, stairs_name, slabs_name, dbl_slabs_name)

	mcl_stairs.register_stair(name, nodename,
			{handy=1,axey=1, flammable=3,wood_stairs=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
			{texture},
			stairs_name,
			mcl_sounds.node_sound_wood_defaults(), 3, 2,
			"woodlike")
			
	mcl_stairs.register_slab(name, nodename,
			{handy=1,axey=1, flammable=3,wood_slab=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
			{texture},
			slabs_name,
			mcl_sounds.node_sound_wood_defaults(), 3, 2,
			dbl_slabs_name)
end

-- name is the name of the node without the mod identifier
-- nodename is the name of the node in question (with mod); will be used for crafting too
-- fence_name is the translated name of the fence
-- fence_gate_name is the translated name of the fence gate
-- fence_tex is the texture used for fence and gates
-- craft_item is the wood item to craft the fences and gate swith
function biolib.register_wooden_fence(name, nodename, fence_name, fence_gate_name, fence_tex)

	local wood_groups = {handy=1,axey=1, flammable=2,fence_wood=1, fire_encouragement=5, fire_flammability=20}
	local wood_connect = {"group:fence_wood"}
	local wood_sounds = mcl_sounds.node_sound_wood_defaults()
	local id = name.."_fence"
	local mod_id = nodename.."_fence"
	local mod_id_gate = nodename.."_fence_gate"
	
	mcl_fences.register_fence_and_fence_gate(id, fence_name, fence_gate_name, fence_tex, wood_groups, 2, 15, wood_connect, wood_sounds)

	minetest.register_craft({
		output = mod_id.." 3",
		recipe = {
			{nodename, "mcl_core:stick", nodename},
			{nodename, "mcl_core:stick", nodename},
		}
	})
	minetest.register_craft({
		output = mod_id_gate,
		recipe = {
			{"mcl_core:stick", nodename, "mcl_core:stick"},
			{"mcl_core:stick", nodename, "mcl_core:stick"},
		}
	})

end

-- nodename is the name of the node in question (with mod)
-- description is the description of the sapling
-- longdesc is the long description for the sapling
-- tt_help is the tooltip for the sapling
-- texture is the texture used for the sapling
-- selbox defines the selection box for the sapling
function biolib.register_sapling(nodename, description, longdesc, tt_help, texture, selbox)
	minetest.register_node(nodename, {
		description = description,
		_tt_help = tt_help,
		_doc_items_longdesc = longdesc,
		_doc_items_hidden = false,
		drawtype = "plantlike",
		waving = 1,
		visual_scale = 1.0,
		tiles = {texture},
		inventory_image = texture,
		wield_image = texture,
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = selbox
		},
		stack_max = 64,
		groups = {
			plant = 1, sapling = 1, non_mycelium_plant = 1, attached_node = 1,
			deco_block = 1, dig_immediate = 3, dig_by_water = 1, dig_by_piston = 1,
			destroy_by_lava_flow = 1, compostability = 30
		},
		sounds = mcl_sounds.node_sound_leaves_defaults(),
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("stage", 0)
		end,
		on_place = mcl_util.generate_on_place_plant_function(function(pos, node)
			local node_below = minetest.get_node_or_nil({x=pos.x,y=pos.y-1,z=pos.z})
			if not node_below then return false end
			local nn = node_below.name
			return minetest.get_item_group(nn, "grass_block") == 1 or
					nn == "mcl_core:podzol" or nn == "mcl_core:podzol_snow" or
					nn == "mcl_core:dirt" or nn == "mcl_core:mycelium" or nn == "mcl_core:coarse_dirt"
		end),
		node_placement_prediction = "",
		_mcl_blast_resistance = 0,
		_mcl_hardness = 0,
	})
end

-- nodename is the name of the node in question (with mod)
-- description is the description of the leaves
-- longdesc is the long description for the leaves
-- tiles is the texture used for the leaves
-- sapling is the name of the sapling, that is being dropped
-- sapling_chances are the chances of the sapling being dropped for a specific fortune level
-- additional_drop is an additional drop {name, drop_chances}. If none given, drops sticks
function biolib.register_leaves(nodename, description, longdesc, tiles, sapling, sapling_chances, additional_drop)
	local stick_chances = {50, 45, 30, 35, 10}
	
	if additional_drop == nil then
		additional_drop = {"mcl_core:stick 2", stick_chances}
	end

	local function get_drops(fortune_level)
		local drop = {
			max_items = 1,
			items = {
				{
					items = {sapling},
					rarity = sapling_chances[fortune_level + 1] or sapling_chances[fortune_level]
				},
				{
					items = {"mcl_core:stick 1"},
					rarity = stick_chances[fortune_level + 1]
				},
				{
					items = {additional_drop[1]},
					rarity = additional_drop[2][fortune_level + 1]
				},
			}
		}
		return drop
	end

	local leaves_def = {
		description = description,
		_doc_items_longdesc = longdesc,
		_doc_items_hidden = false,
		drawtype = "allfaces_optional",
		waving = 2,
		place_param2 = 1, -- Prevent leafdecay for placed nodes
		tiles = tiles,
		paramtype = "light",
		stack_max = 64,
		groups = {
			handy = 1, hoey = 1, shearsy = 1, swordy = 1, dig_by_piston = 1,
			leaves = 1, deco_block = 1,
			flammable = 2, fire_encouragement = 30, fire_flammability = 60,
			compostability = 30
		},
		drop = get_drops(0),
		_mcl_shears_drop = true,
		sounds = mcl_sounds.node_sound_leaves_defaults(),
		_mcl_blast_resistance = 0.2,
		_mcl_hardness = 0.2,
		_mcl_silk_touch_drop = true,
		_mcl_fortune_drop = { get_drops(1), get_drops(2), get_drops(3), get_drops(4) },
	}

	local leaves_orphan_def = table.copy(leaves_def)

	leaves_orphan_def._doc_items_create_entry = false
	leaves_orphan_def.place_param2 = nil
	leaves_orphan_def.groups.not_in_creative_inventory = 1
	leaves_orphan_def.groups.orphan_leaves = 1
	leaves_orphan_def._mcl_shears_drop = {nodename}
	leaves_orphan_def._mcl_silk_touch_drop = {nodename}

	minetest.register_node(nodename, leaves_def)
	minetest.register_node(nodename.."_orphan", leaves_orphan_def)
end

-- Custom Sapling related Functions --------------------------------------------

biolib.__custom_saplings = {}
biolib.__orig_grow_sapling = mcl_core.grow_sapling

function biolib.__grow_sapling(pos, node)

	local grow_function = biolib.__custom_saplings[node.name]

	if grow_function then
		if grow_function(pos) then
			return true
		else
			return false
		end
	end
		
	return biolib.__orig_grow_sapling(pos, node)
end

-- override original grow sampling method with augmented one
mcl_core.grow_sapling = biolib.__grow_sapling

-- name is the name of the sapling in question
-- the grow function is the function, that is for actually growing the sapling
function biolib.register_bonemeal_sapling(name, grow_func)
	biolib.__custom_saplings[name] = grow_func
end

-- Custom Treetap related Functions --------------------------------------------


-- Check if placement at given node is allowed
function biolib._check_placement_allowed(node, wdir)
	-- Torch placement rules: Disallow placement on some nodes. General rule: Solid, opaque, full cube collision box nodes are allowed.
	-- Special allowed nodes:
	-- * soul sand
	-- * mob spawner
	-- * chorus flower
	-- * glass, barrier, ice
	-- * Fence, wall, end portal frame with ender eye: Only on top
	-- * Slab, stairs: Only on top if upside down

	-- Special forbidden nodes:
	-- * Piston, sticky piston
	local def = minetest.registered_nodes[node.name]
	if not def then
		return false
	-- No ceiling torches
	elseif wdir == 0 then
		return false
	elseif not def.buildable_to then
		if node.name ~= "mcl_core:ice" and node.name ~= "mcl_nether:soul_sand" and node.name ~= "mcl_mobspawners:spawner" and node.name ~= "mcl_core:barrier" and node.name ~= "mcl_end:chorus_flower" and node.name ~= "mcl_end:chorus_flower_dead" and (not def.groups.glass) and
				((not def.groups.solid) or (not def.groups.opaque)) then
			-- Only allow top placement on these nodes
			if node.name == "mcl_end:dragon_egg" or node.name == "mcl_portals:end_portal_frame_eye" or def.groups.fence == 1 or def.groups.wall or def.groups.slab_top == 1 or def.groups.anvil or def.groups.pane or (def.groups.stair == 1 and minetest.facedir_to_dir(node.param2).y ~= 0) then
				if wdir ~= 1 then
					return false
				end
			else
				return false
			end
		elseif minetest.get_item_group(node.name, "piston") >= 1 then
			return false
		end
	end
	return true
end

-- nodename is the name of the node (and their variants)
-- description is the translated name of the node
-- help is the tooltip text of the node
-- long_desc is the long description for this node
-- usage is the usage text for this node
-- resource_name will be used to generate all the resource paths
-- attach_name is the name of the node it can attach to.
-- final_drop is the drop that you get, when the treetap is filled
-- fill_level is the incremental value of what the fill level is.
function biolib.register_treetap_variant(nodename, description, help, long_desc, usage, resource_name, attach_name, final_drop, fill_level)
	
	local indexed_nodename = nodename
	local indexed_resource_name = resource_name
	
	if fill_level > 0 then
		indexed_nodename = nodename.."_"..fill_level
		indexed_resource_name = resource_name.."_"..fill_level
	end
	
	local groups = {}
	local config = {}
	
	-- general data
	config.stack_max = 64
	if fill_level > 0 then
		config._doc_items_create_entry = false
		config._doc_items_hidden = true
	else
		config.description = description
		config._tt_help = help
		config._doc_items_longdesc = long_desc
		config._doc_items_usagehelp = usage
	end
	
	-- graphics related date
	config.drawtype = "mesh"
	config.mesh = indexed_resource_name..".obj"
	config.tiles = {resource_name..".png"}
	config.use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "clip" or true
	config.inventory_image = resource_name.."_inv.png"
	config.wield_image = resource_name.."_inv.png"
	config.wield_scale = {x=1.0, y=1.0, z=1.0}
	config.selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
	}
	
	-- node related data
	config._mcl_blast_resistance = 1.3
	config._mcl_hardness = 0.7
	groups.handy = 1
	groups.axey = 1
	groups.flammable = 3
	groups.fire_encouragement = 5
	groups.fire_flammability = 20
	config.collision_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
	}
	
	-- sound related stuff
	config.sounds = mcl_sounds.node_sound_wood_defaults()
	
	-- placement related config
	config.node_placement_prediction = ""
	config.liquids_pointable = false
	if fill_level == 0 then
		config.on_place = function(itemstack, placer, pointed_at)
		
			-- there is nothing pointed at
			if pointed_at.type ~= "node" then
				return itemstack
			end
			
			local under = pointed_at.under
			local node = minetest.get_node(under)
			local def = minetest.registered_nodes[node.name]
			if not def then return itemstack end
			
			-- there is something pointed at, but it's this specific node
			if node.name ~= attach_name then
				return itemstack
			end

			-- Call on_rightclick if the pointed node defines it
			if placer and not placer:get_player_control().sneak then
				if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
					return minetest.registered_nodes[node.name].on_rightclick(under, node, placer, itemstack) or itemstack
				end
			end
			
			local above = pointed_at.above
			local wdir = minetest.dir_to_wallmounted({x = under.x - above.x, y = under.y - above.y, z = under.z - above.z})
			if biolib._check_placement_allowed(node, wdir) == false then
				return itemstack
			end
			
			if wdir == 1 or wdir == 0 then
				return itemstack
			end
			
			local success
			itemstack, success = minetest.item_place(itemstack, placer, pointed_at, wdir)
			
			if success and config.sounds and config.sounds.place then
				minetest.sound_play(config.sounds.place, {pos=under, gain=1}, true)
			end
			return itemstack
		end
	end
	
	if fill_level == 4 then
		config.on_rightclick = function(pos, node, player, itemstack)
			if not player:get_player_control().sneak then
				local new_stack = ItemStack(final_drop)
				local random_pos = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
				local new_node = {name = nodename, param1 = node.param1, param2 = node.param2}
				
				minetest.add_item(pos, new_stack)
				minetest.swap_node(pos, new_node)
			end
			return itemstack
		end
	end
	
	-- misc config stuff
	config.on_rotate = false
	config.paramtype = "light"
	config.paramtype2 = "wallmounted"
	config.sunlight_propagates = true
	config.is_ground_content = false
	config.drop = nodename
	
	-- other group related stuff
	groups.attached_node = 1
	groups.dig_by_water = 1
	groups.destroy_by_lava_flow = 1
	groups.dig_by_piston = 1
	groups.resin_fill = fill_level
	groups.treetap = 1
	
	config.groups = groups
	
	minetest.register_node(indexed_nodename, config)
end

-- nodenames is the list of node names that are triggered by the world
-- depends_on is a variable that restricts the updates to nodes with specific neighbors. nil will ignore the setting.
-- abm_label is the label for the register_abm function
-- lbm_label is the label for the register_lbm function
-- lbm_name is the unique name for the register_lbm function
-- interval is the updating interval
-- chance is the chance of it being triggered
-- update_func is the actual function to update in the world
function biolib.register_world_updates(nodenames, depends_on, abm_label, lbm_label, lbm_name, interval, chance, update_func)
	local config_abm = {}
	local config_lbm = {}
	
	config_abm.label = abm_label
	config_lbm.label = lbm_label
	config_abm.nodenames = nodenames
	config_abm.nodenames = nodenames
	config_lbm.name = lbm_name
	
	if depends_on then
		config_abm.neighbors = depends_on
	end
	
	config_abm.interval = interval
	config_abm.chance = chance
	config_abm.action = update_func
	config_lbm.action = update_func
	config_lbm.run_at_every_load = true
	
	minetest.register_abm(config_abm)
	minetest.register_lbm(config_lbm)
end

-- Custom effects/events related functions -------------------------------------

-- use this with minetest.register_on_player_hpchange
-- this function enables footgear to be in the fall_damage_add_percent group
function biolib.do_modify_falldamage_with_boots(player, hp_change, mt_reason)
	if hp_change < 0 and mt_reason["type"] == "fall" and player and player:is_player() then
		local playername = player:get_player_name()
		local inventory = mcl_util.get_inventory(player, true)
		local boots = inventory:get_stack("armor", mcl_armor.elements.feet.index)
		local fall_damage = minetest.get_item_group(boots:get_name(), "fall_damage_add_percent")
		if not fall_damage == 0 then
			local hp_change_mod = fall_damage * hp_change / 100
			local hp_diff = hp_change + hp_change_mod
			local hp_remainder = hp_change - hp_diff
			mcl_util.use_item_durability(boots, math.abs(hp_remainder))
			inventory:set_stack("armor", mcl_armor.elements.feet.index, boots)
			return hp_diff
		end
	end
	return hp_change
end
