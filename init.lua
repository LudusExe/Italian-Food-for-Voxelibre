local S = minetest.get_translator(minetest.get_current_modname())
local mod = minetest.get_modpath("italian_food")
local mofood_longdesc = S("A delicious dish made from fresh ingredients.")
dofile(mod .. "/crafting.lua") -- load Crafting Recipes
dofile(mod .. "/pizzeria.lua") -- load the Pizzeria Structure

potionmod = potionmod or {}
potionmod.potions = potionmod.potions or {}
function potionmod.register_potion_type(name, def)
    potionmod.potions[name] = def
end

function potionmod.apply_effect(player, effect_name, duration, strength)
    if effect_name == "speed" then
        local name = player:get_player_name()
        player:set_physics_override({speed = 1 + 0.5 * strength})
        minetest.after(duration, function()
            local p = minetest.get_player_by_name(name)
            if p then
                p:set_physics_override({speed = 1})
            end
        end)
    end
end


local function register_food_item(name, description, image, saturation, eat_value)
    minetest.register_craftitem(name, {
        description = description,
        _doc_items_longdesc = mofood_longdesc,
        inventory_image = image,
        groups = {food = 2, eatable = eat_value},
        _mcl_saturation = saturation,
        on_place = minetest.item_eat(eat_value),
        on_secondary_use = minetest.item_eat(eat_value),
    })
end

register_food_item("italian_food:pizza", S("Pizza"), "italian_food_pizza.png", 16, 15)
register_food_item("italian_food:mushroom_pizza", S("Mushroom Pizza"), "italian_food_mushroom_pizza.png", 16, 18)
register_food_item("italian_food:lasagna", S("Lasagna"), "italian_food_lasagna.png", 13, 10)
register_food_item("italian_food:spaghetti", S("Tomato Spaghetti"), "italian_food_spaghetti.png", 12, 10)
register_food_item("italian_food:dough", S("Dough"), "italian_food_dough.png", 10, 10)
register_food_item("italian_food:spaghetti_raw", S("Raw Spaghetti"), "italian_food_spaghetti_raw.png", 10, 10)
register_food_item("italian_food:raviolo_raw", S("Raw Raviolo"), "italian_food_raviolo.png", 12, 12)
register_food_item("italian_food:gnocco_raw", S("Raw Gnocco"), "italian_food_gnocco.png", 11, 10)
register_food_item("italian_food:fazzoletto_raw", S("Raw Fazzoletto"), "italian_food_fazzoletti.png", 11, 11)
register_food_item("italian_food:bruschetta", S("Bruschetta"), "italian_food_bruschetta.png", 20, 18)
register_food_item("italian_food:canoli", S("Cannoli"), "italian_food_canoli.png", 20, 18)
register_food_item("italian_food:mozzarella", S("Mozzarella"), "italian_food_mozzarella.png", 8.5, 9)
register_food_item("italian_food:sheep_milk_bucket", S("Sheep Milk Bucket"), "italian_food_sheep_milk_bucket.png", 8.5, 9)
register_food_item("italian_food:sheep_cheese", S("Sheep Cheese"), "italian_food_sheep_cheese.png", 9,8)
register_food_item("italian_food:tomato", S("Tomato"), "italian_food_tomato.png", 8.5, 9)
register_food_item("italian_food:basil", S("Basil"), "italian_food_basil.png", 3,4)
register_food_item("italian_food:tomato_sauce", S("Tomato Sauce"), "italian_food_tomato_sauce.png", 7.5,8)
register_food_item("italian_food:pesto_sauce", S("Pesto Sauce"), "italian_food_pesto_sauce.png", 7.5,8)
register_food_item("italian_food:tiramisu", S("Tiramisu"), "italian_food_tiramisu.png", 12, 8)
register_food_item("italian_food:ice_cream", S("Chocolate Ice Cream"), "italian_food_ice_cream.png", 8, 12)
register_food_item("italian_food:cone", S("Ice Cream Cone"), "italian_food_cone.png", 4, 6)
register_food_item("italian_food:panettone", S("Panettone"), "italian_food_panettone.png", 7, 8)
register_food_item("italian_food:pandoro", S("Pandoro"), "italian_food_pandoro.png", 7, 8)
register_food_item("italian_food:coffee", S("Coffee"), "italian_food_coffee.png", 7.5,8)
register_food_item("italian_food:sunflowerolio",S("Sunflower Oil"), "italian_food_sunfloweroil.png", 5, 3)    
register_food_item("italian_food:pork_jowl",S("Pork Jowl"), "italian_food_pork_jowl.png", 5, 3)

-- plants
local function on_bone_meal(itemstack,placer,pointed_thing,pos,node)
    plant_series = nil
    if string.find(node.name,"tomato_plant") then
        plant_series = "plant_tomato"
    elseif string.find(node.name,"basil_plant") then
        plant_series = "plant_basil"
    end
    return mcl_farming.on_bone_meal(itemstack,placer,pointed_thing,pos,node,plant_series)
end

-- Register Basil Seeds craftitem
minetest.register_craftitem("italian_food:basil_seeds", {
    description = S("Basil Seeds"),
    _tt_help = S("Grows on farmland"),
    _doc_items_longdesc = S("Grows into a basil plant."),
    _doc_items_usagehelp = S("Place the tomato seeds on farmland (created with a hoe) to plant a tomato plant.") .. "\n" ..
                           S("They grow in sunlight and grow faster on hydrated farmland."),
    groups = {craftitem = 1, compostability = 30},
    inventory_image = "italian_food_basil_seeds.png",
    on_place = function(itemstack, placer, pointed_thing)
        return mcl_farming:place_seed(itemstack, placer, pointed_thing, "italian_food:basil_plant_1")
    end,
})

-- Selection box heights for each growth stage
local sel_heights = {
    -5/16,
    -2/16,
    0,
    3/16,
    5/16,
    5/16,
    5/16,
}

-- Register basil plant growth stages (1 to 7)
for stage = 1, 7 do
    local create_doc_entry = (stage == 1)
    local doc_name = create_doc_entry and S("Premature Basil Plant") or nil
    local doc_longdesc = create_doc_entry and
        S("Premature basil plants grow on farmland under sunlight through 7 stages.") .. "\n" ..
        S("They grow faster on hydrated farmland. They can be harvested at any time but yield profit only when mature.") or nil

    minetest.register_node("italian_food:basil_plant_" .. stage, {
        description = S("Premature Basil Plant (Stage @1)", stage),
        _doc_items_create_entry = create_doc_entry,
        _doc_items_entry_name = doc_name,
        _doc_items_longdesc = doc_longdesc,
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 3,
        sunlight_propagates = true,
        walkable = false,
        drawtype = "plantlike",
        drop = "italian_food:basil_seeds",
        tiles = {"italian_food_basil_stage_" .. (stage - 1) .. ".png"},
        inventory_image = "italian_food_basil_stage_" .. (stage - 1) .. ".png",
        wield_image = "italian_food_basil_stage_" .. (stage - 1) .. ".png",
        selection_box = {
            type = "fixed",
            fixed = { {-0.5, -0.5, -0.5, 0.5, sel_heights[stage], 0.5} },
        },
        groups = {
            dig_immediate = 3,
            not_in_creative_inventory = 1,
            plant = 1,
            attached_node = 1,
            dig_by_water = 1,
            destroy_by_lava_flow = 1,
            dig_by_piston = 1,
        },
        sounds = mcl_sounds.node_sound_leaves_defaults(),
        _mcl_blast_resistance = 0,
        _on_bone_meal = function(itemstack, placer, pointed_thing)
            local pos = pointed_thing.under
            local node = minetest.get_node(pos)
            local growth_stages = math.random(2, 5)
            return mcl_farming:grow_plant("plant_basil", pos, node, growth_stages, true)
        end,
    })
end

-- Register mature basil plant node
minetest.register_node("italian_food:basil_plant", {
    description = S("Mature Basil Plant"),
    _doc_items_longdesc = S("Mature basil plants are ready to be harvested for basil and basil seeds.") .. "\n" ..
                          S("They do not grow any further."),
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "meshoptions",
    place_param2 = 3,
    walkable = false,
    drawtype = "plantlike",
    tiles = {"italian_food_basil_plant_mature.png"},
    inventory_image = "italian_food_basil_plant_mature.png",
    wield_image = "italian_food_basil_plant_mature.png",
    drop = {
        max_items = 4,
        items = {
            { items = {"italian_food:basil"}, rarity = 1 },
            { items = {"italian_food:basil 4"}, rarity = 3 },
            { items = {"italian_food:basil_seeds"}, rarity = 1 },
            { items = {"italian_food:basil_seeds 3"}, rarity = 4 },
        }
    },
    groups = {
        dig_immediate = 3,
        not_in_creative_inventory = 1,
        plant = 1,
        attached_node = 1,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        dig_by_piston = 1,
    },
    sounds = mcl_sounds.node_sound_leaves_defaults(),
    _mcl_blast_resistance = 0,
    _mcl_fortune_drop = {
        discrete_uniform_distribution = true,
        items = {"italian_food:basil_seeds"},
        drop_without_fortune = {"italian_food:basil"},
        min_count = 1,
        max_count = 6,
        cap = 7,
    },
})

-- Register basil plant with farming API
mcl_farming:add_plant(
    "plant_basil",
    "italian_food:basil_plant",
    {
        "italian_food:basil_plant_1",
        "italian_food:basil_plant_2",
        "italian_food:basil_plant_3",
        "italian_food:basil_plant_4",
        "italian_food:basil_plant_5",
        "italian_food:basil_plant_6",
        "italian_food:basil_plant_7",
    },
    5.8020,
    35
)

-- Register Tomato Seeds craftitem
minetest.register_craftitem("italian_food:tomato_plant_seeds", {
    description = S("Tomato Seeds"),
    _tt_help = S("Grows on farmland"),
    _doc_items_longdesc = S("Grows into a tomato plant."),
    _doc_items_usagehelp = S("Place the tomato seeds on farmland (created with a hoe) to plant a tomato plant.") .. "\n" ..
                           S("They grow in sunlight and grow faster on hydrated farmland. Right-click an animal to feed it tomato seeds."),
    groups = {craftitem = 1, compostability = 30},
    inventory_image = "italian_food_tomato_plant_seeds.png",
    on_place = function(itemstack, placer, pointed_thing)
        return mcl_farming:place_seed(itemstack, placer, pointed_thing, "italian_food:tomato_plant_1")
    end,
})

-- Selection box heights for each growth stage
local sel_heights = {
    -5/16,
    -2/16,
    0,
    3/16,
    5/16,
    6/16,
    7/16,
}

-- Register tomato plant growth stages (1 to 5)
for stage = 1, 7 do
    local create_doc_entry = (stage == 1)
    local doc_name = create_doc_entry and S("Premature Tomato Plant") or nil
    local doc_longdesc = create_doc_entry and
        S("Premature tomato plants grow on farmland under sunlight through 7 stages.") .. "\n" ..
        S("They grow faster on hydrated farmland. They can be harvested at any time but yield profit only when mature.") or nil

    minetest.register_node("italian_food:tomato_plant_" .. stage, {
        description = S("Premature Tomato Plant (Stage @1)", stage),
        _doc_items_create_entry = create_doc_entry,
        _doc_items_entry_name = doc_name,
        _doc_items_longdesc = doc_longdesc,
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 3,
        sunlight_propagates = true,
        walkable = false,
        drawtype = "plantlike",
        drop = "italian_food:tomato_plant_seeds",
        tiles = {"italian_food_tomato_stage_" .. (stage - 1) .. ".png"},
        inventory_image = "italian_food_tomato_stage_" .. (stage - 1) .. ".png",
        wield_image = "italian_food_tomato_stage_" .. (stage - 1) .. ".png",
        selection_box = {
            type = "fixed",
            fixed = { {-0.5, -0.5, -0.5, 0.5, sel_heights[stage], 0.5} },
        },
        groups = {
            dig_immediate = 3,
            not_in_creative_inventory = 1,
            plant = 1,
            attached_node = 1,
            dig_by_water = 1,
            destroy_by_lava_flow = 1,
            dig_by_piston = 1,
        },
        sounds = mcl_sounds.node_sound_leaves_defaults(),
        _mcl_blast_resistance = 0,
        _on_bone_meal = function(itemstack, placer, pointed_thing)
            local pos = pointed_thing.under
            local node = minetest.get_node(pos)
            local growth_stages = math.random(2, 5)
            return mcl_farming:grow_plant("plant_tomato", pos, node, growth_stages, true)
        end,
    })
end

-- Register mature tomato plant node
minetest.register_node("italian_food:tomato_plant", {
    description = S("Mature Tomato Plant"),
    _doc_items_longdesc = S("Mature tomato plants are ready to be harvested for tomatoes and tomato seeds.") .. "\n" ..
                          S("They do not grow any further."),
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "meshoptions",
    place_param2 = 3,
    walkable = false,
    drawtype = "plantlike",
    tiles = {"italian_food_tomato_plant_mature.png"},
    inventory_image = "italian_food_tomato_plant_mature.png",
    wield_image = "italian_food_tomato_plant_mature.png",
    drop = {
        max_items = 4,
        items = {
            { items = {"italian_food:tomato"}, rarity = 1 },
            { items = {"italian_food:tomato 2"}, rarity = 3 },
            { items = {"italian_food:tomato_plant_seeds 2"}, rarity = 1 },
            { items = {"italian_food:tomato_plant_seeds 4"}, rarity = 3 },
        }
    },
    groups = {
        dig_immediate = 3,
        not_in_creative_inventory = 1,
        plant = 1,
        attached_node = 1,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        dig_by_piston = 1,
    },
    sounds = mcl_sounds.node_sound_leaves_defaults(),
    _mcl_blast_resistance = 0,
    _mcl_fortune_drop = {
        discrete_uniform_distribution = true,
        items = {"italian_food:tomato_plant_seeds"},
        drop_without_fortune = {"italian_food:tomato"},
        min_count = 1,
        max_count = 6,
        cap = 7,
    },
})

-- Register tomato plant with farming API
mcl_farming:add_plant(
    "plant_tomato",
    "italian_food:tomato_plant",
    {
        "italian_food:tomato_plant_1",
        "italian_food:tomato_plant_2",
        "italian_food:tomato_plant_3",
        "italian_food:tomato_plant_4",
        "italian_food:tomato_plant_5",
        "italian_food:tomato_plant_6",
        "italian_food:tomato_plant_7",
    },
    5.8020,
    35
)


--achievements
awards.register_achievement("italian_food:pizza_eating", {
	title = S("Welcome to Italy!"),
	icon = "italian_food_pizza.png",
	description = S("Eat a pizza slice."),
	trigger = {
		type = "eat",
		item= "italian_food:pizza",
		target = 1,
	}
})
awards.register_achievement("italian_food:mushroom_pizza_eating", {
	title = S("Mushrooms? Don't tell Mario!"),
	icon = "italian_food_mushroom_pizza.png",
	description = S("Eat a pizza slice with mushrooms."),
	trigger = {
		type = "eat",
		item= "italian_food:mushroom_pizza",
		target = 1,
	}
})
awards.register_achievement("italian_food:bruschetta_eating", {
	title = S("A simple snack!"),
	icon = "italian_food_bruschetta.png",
	description = S("Eat a Bruschetta."),
	trigger = {
		type = "eat",
		item= "italian_food:bruschetta",
		target = 1,
	}
})

-- items that aren't food
minetest.register_tool("italian_food:rolling_pin", {
    description = S("Rolling Pin"),
    inventory_image = "italian_food_rolling_pin.png",
    tool_capabilities = {
        full_punch_interval = 1.2,
        max_drop_level = 0,
        groupcaps = {
            crumbly = {times = {[1] = 2.0, [2] = 1.00, [3] = 0.50}, uses = 25, maxlevel = 1},
        },
        damage_groups = {fleshy = 1},
    },
    groups = {wooden_tool = 1},
})


-- cheese rack
local CHEESE_TIME = 30  -- secondi per produrre il formaggio

minetest.register_node("italian_food:cheese_rack", {
    description = S("Cheese Rack"),
    tiles = {
        "italian_food_cheese_rack_top.png", "italian_food_cheese_rack_top.png",
        "italian_food_cheese_rack_side.png", "italian_food_cheese_rack_side.png",
        "italian_food_cheese_rack_side.png", "italian_food_cheese_rack_front.png"
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    sounds = mcl_sounds.node_sound_wood_defaults(),
    paramtype2 = "facedir",

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 2)
        meta:set_int("cheese_time", 0)
        meta:set_string("infotext", "Cheese Rack (empty)")

        meta:set_string("formspec", [[
            size[8,9]
            label[0,0;Sheep Milk → Cheese]
            list[current_name;input;2,1;1,1;]
            list[current_name;output;5,1;2,1;]
            list[current_player;main;0,5;8,4;]
        ]])
    end,

    can_dig = function(pos, player)
        local inv = minetest.get_meta(pos):get_inventory()
        return inv:is_empty("input") and inv:is_empty("output")
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local input_stack = inv:get_stack("input", 1)
        local timer = meta:get_int("cheese_time")

        if input_stack:get_name() ~= "italian_food:sheep_milk_bucket" then
            meta:set_string("infotext", "Cheese Rack (empty)")
            meta:set_int("cheese_time", 0)
            return false  -- stop timer
        end

        timer = timer + elapsed

        if timer >= CHEESE_TIME then
            if inv:room_for_item("output", "italian_food:sheep_cheese") and
               inv:room_for_item("output", "mcl_buckets:bucket_empty") then

                inv:add_item("output", "italian_food:sheep_cheese")
                inv:add_item("output", "mcl_buckets:bucket_empty")
                input_stack:take_item()
                inv:set_stack("input", 1, input_stack)
                timer = 0
            end
        end

        meta:set_int("cheese_time", timer)
        meta:set_string("infotext", "Cheese Rack (fermenting...)")
        return true  -- keep timer running
    end,

    on_metadata_inventory_put = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if not inv:get_stack("input", 1):is_empty() then
            minetest.get_node_timer(pos):start(1.0)
            meta:set_string("infotext", "Cheese Rack (fermenting...)")
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:get_stack("input", 1):is_empty() then
            minetest.get_node_timer(pos):stop()
            meta:set_string("infotext", "Cheese Rack (empty)")
        end
    end,
})

-- potion idea
mcl_potions.register_potion({
   name = "sugar_coffe",
   _id_override = "italian_food:sugar_coffe", -- only change
   desc_suffix = S("of Sugar Coffe"),
   _tt = nil,
   _longdesc = S("Increases walking, placing and digging speed and jump boost."),
   color = "#531B00",
   _effect_list = {
      swiftness = {},
        haste = {},
        leaping = {},
   },
   has_arrow = false,
})








   
































-- Hey doesn't tiramisu also use coffee and eggs? >;p         Inspired by a real dessert and a caffeine-fueled coding session!
