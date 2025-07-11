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

register_food_item("italian_food:pizza", S("Pizza"), "pizza.png", 16, 15)
register_food_item("italian_food:mushroom_pizza", S("Mushroom Pizza"), "mushroom_pizza.png", 16, 18)
register_food_item("italian_food:lasagna", S("Lasagna"), "lasagna.png", 13, 10)
register_food_item("italian_food:spaghetti", S("Tomato Spaghetti"), "spaghetti.png", 12, 10)
register_food_item("italian_food:dough", S("Dough"), "dough.png", 10, 10)
register_food_item("italian_food:spaghetti_raw", S("Raw Spaghetti"), "spaghetti_raw.png", 10, 10)
register_food_item("italian_food:raviolo_raw", S("Raw Raviolo"), "raviolo.png", 12, 12)
register_food_item("italian_food:gnocco_raw", S("Raw Gnocco"), "gnocco.png", 11, 10)
register_food_item("italian_food:fazzoletto_raw", S("Raw Fazzoletto"), "fazzoletti.png", 11, 11)
register_food_item("italian_food:bruschetta", S("Bruschetta"), "bruschetta.png", 20, 18)
register_food_item("italian_food:canoli", S("Cannoli"), "canoli.png", 20, 18)
register_food_item("italian_food:mozzarella", S("Mozzarella"), "mozzarella.png", 8.5, 9)
register_food_item("italian_food:sheep_milk_bucket", S("Sheep Milk Bucket"), "sheep_milk_bucket.png", 8.5, 9)
register_food_item("italian_food:sheep_cheese", S("Sheep Cheese"), "sheep_cheese.png", 9,8)
register_food_item("italian_food:tomato", S("Tomato"), "tomato.png", 8.5, 9)
register_food_item("italian_food:basil", S("Basil"), "basil.png", 3,4)
register_food_item("italian_food:tomato_sauce", S("Tomato Sauce"), "tomato_sauce.png", 7.5,8)
register_food_item("italian_food:pesto_sauce", S("Pesto Sauce"), "pesto_sauce.png", 7.5,8)
register_food_item("italian_food:tiramisu", S("Tiramisu"), "tiramisu.png", 12, 8)
register_food_item("italian_food:ice_cream", S("Chocolate Ice Cream"), "ice_cream.png", 8, 12)
register_food_item("italian_food:cone", S("Ice Cream Cone"), "cone.png", 4, 6)
register_food_item("italian_food:panettone", S("Panettone"), "panettone.png", 7, 8)
register_food_item("italian_food:pandoro", S("Pandoro"), "pandoro.png", 7, 8)
register_food_item("italian_food:coffee", S("Coffee"), "coffee.png", 7.5,8)
register_food_item("italian_food:sunflowerolio",S("Sunflower Oil"), "sunfloweroil.png", 5, 3)    
register_food_item("italian_food:pork_jowl",S("Pork Jowl"), "pork_jowl.png", 5, 3)

-- plants
-- basil plant
minetest.register_node("italian_food:basil_plant", {
    description = S("Basil Plant"),
    drawtype = "plantlike",
    tiles = {"basil_plant.png"},
    groups = {snappy = 3, flammable = 2, plant = 1},
    sounds = default and default.node_sound_leaves_defaults() or nil,
    drop = "italian_food:basil",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
})
minetest.register_abm({
    nodenames = {"group:grass"},
    neighbors = {"group:soil"},
    interval = 60,
    chance = 30, 
    action = function(pos, node)
        local basil_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        if minetest.get_node(basil_pos).name == "air" then
            if minetest.get_node(pos).name == "group:grass" then
                minetest.set_node(basil_pos, {name = "italian_food:basil_plant"})
            end
        end
    end
})
-- Tomato Plant and Seeds registration

local S = minetest.get_translator("italian_food")

-- Register Tomato Seeds craftitem
minetest.register_craftitem("italian_food:tomato_seeds", {
    description = S("Tomato Seeds"),
    _tt_help = S("Grows on farmland"),
    _doc_items_longdesc = S("Grows into a tomato plant."),
    _doc_items_usagehelp = S("Place the tomato seeds on farmland (created with a hoe) to plant a tomato plant.") .. "\n" ..
                           S("They grow in sunlight and grow faster on hydrated farmland. Right-click an animal to feed it tomato seeds."),
    groups = {craftitem = 1, compostability = 30},
    inventory_image = "tomato_seeds.png",
    on_place = function(itemstack, placer, pointed_thing)
        return mcl_farming:place_seed(itemstack, placer, pointed_thing, "italian_food:tomato_1")
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
for stage = 1, 5 do
    local create_doc_entry = (stage == 1)
    local doc_name = create_doc_entry and S("Premature Tomato Plant") or nil
    local doc_longdesc = create_doc_entry and
        S("Premature tomato plants grow on farmland under sunlight through 5 stages.") .. "\n" ..
        S("They grow faster on hydrated farmland. They can be harvested at any time but yield profit only when mature.") or nil

    minetest.register_node("italian_food:tomato_" .. stage, {
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
        drop = "italian_food:tomato_seeds",
        tiles = {"tomato_stage_" .. (stage - 1) .. ".png"},
        inventory_image = "tomato_stage_" .. (stage - 1) .. ".png",
        wield_image = "tomato_stage_" .. (stage - 1) .. ".png",
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
    tiles = {"tomato_plant_mature.png"},
    inventory_image = "tomato_plant_mature.png",
    wield_image = "tomato_plant_mature.png",
    drop = {
        max_items = 4,
        items = {
            { items = {"italian_food:tomato_seeds"} },
            { items = {"italian_food:tomato_seeds"}, rarity = 2 },
            { items = {"italian_food:tomato_item"}, rarity = 5 },
            { items = {"italian_food:tomato_item"} },
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
        items = {"italian_food:tomato_seeds"},
        drop_without_fortune = {"italian_food:tomato_item"},
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
        "italian_food:tomato_1",
        "italian_food:tomato_2",
        "italian_food:tomato_3",
        "italian_food:tomato_4",
        "italian_food:tomato_5"
    },
    5.8020,
    35
)


--achievements
awards.register_achievement("italian_food:pizza_eating", {
	title = S("Welcome to Italy!"),
	icon = "pizza.png",
	description = S("Eat a pizza slice."),
	trigger = {
		type = "eat",
		item= "italian_food:pizza",
		target = 1,
	}
})
awards.register_achievement("italian_food:mushroom_pizza_eating", {
	title = S("Mushrooms? Don't tell Mario!"),
	icon = "mushroom_pizza.png",
	description = S("Eat a pizza slice with mushrooms."),
	trigger = {
		type = "eat",
		item= "italian_food:mushroom_pizza",
		target = 1,
	}
})
awards.register_achievement("italian_food:bruschetta_eating", {
	title = S("A simple snack!"),
	icon = "bruschetta.png",
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
    inventory_image = "rolling_pin.png",
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
        "cheese_rack_top.png", "cheese_rack_top.png",
        "cheese_rack_side.png", "cheese_rack_side.png",
        "cheese_rack_side.png", "cheese_rack_front.png"
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

