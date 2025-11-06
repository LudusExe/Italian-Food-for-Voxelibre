local S = minetest.get_translator("italian_food")
local mod = minetest.get_modpath("italian_food")
local mofood_longdesc = S("A delicious dish made from fresh ingredients.")
italian_food = italian_food or {}

function italian_food.olive_sapling_grow_action(level, sapling_name, grow_time)
    return function(pos)
        minetest.set_node(pos, {name = "italian_food:olivetree"})
    end
end

dofile(mod .. "/biolib.lua")
local olive_tree_init = dofile(mod .. "/olive_tree.lua")
dofile(mod .. "/crafting.lua")
dofile(mod .. "/pizzeria.lua")
dofile(mod .. "/crops.lua")
olive_tree_init(S, mod, biolib, italian_food)

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
register_food_item("italian_food:tomato_sauce_bruschetta", S("Tomato Sauce Bruschetta"), "italian_food_tosauce_bruschetta.png", 24, 20)
register_food_item("italian_food:pesto_bruschetta", S("Pesto Sauce Bruschetta"), "italian_food_pesauce_bruschetta.png", 24, 20)
register_food_item("italian_food:canoli", S("Cannoli"), "italian_food_canoli.png", 20, 18)
register_food_item("italian_food:mozzarella", S("Mozzarella"), "italian_food_mozzarella.png", 8.5, 9)
register_food_item("italian_food:sheep_milk_bucket", S("Sheep Milk Bucket"), "italian_food_sheep_milk_bucket.png", 8.5, 9)
register_food_item("italian_food:sheep_cheese", S("Sheep Cheese"), "italian_food_sheep_cheese.png", 9,8)
register_food_item("italian_food:tomato", S("Tomato"), "italian_food_tomato.png", 8.5, 9)
register_food_item("italian_food:diamond_tomato", S("Diamond Tomato"), "italian_food_diamond_tomato.png", 75, 75) -- I know this is OP, but when in survival you have 8 blocks of diamond?
register_food_item("italian_food:basil", S("Basil"), "italian_food_basil.png", 3,4)
register_food_item("italian_food:diamond_basil", S("Diamond Basil"), "italian_food_diamond_basil.png", 50, 50) -- like the diamond tomato up there
register_food_item("italian_food:olive", S("Olives"), "italian_food_olive.png", 3,4)
register_food_item("italian_food:tomato_sauce", S("Tomato Sauce"), "italian_food_tomato_sauce.png", 7.5,8)
register_food_item("italian_food:pesto_sauce", S("Pesto Sauce"), "italian_food_pesto_sauce.png", 7.5,8)
register_food_item("italian_food:tiramisu", S("Tiramisu"), "italian_food_tiramisu.png", 12, 8)
register_food_item("italian_food:ice_cream", S("Chocolate Ice Cream"), "italian_food_ice_cream.png", 8, 12)
register_food_item("italian_food:cone", S("Ice Cream Cone"), "italian_food_cone.png", 4, 6)
register_food_item("italian_food:panettone", S("Panettone"), "italian_food_panettone.png", 7, 8)
register_food_item("italian_food:pandoro", S("Pandoro"), "italian_food_pandoro.png", 7, 8)
register_food_item("italian_food:coffee", S("Coffee"), "italian_food_coffee.png", 7.5,8)
register_food_item("italian_food:coffee_roasted_bean", S("Roasted Coffee Bean"), "italian_food_roasted_coffee_bean.png", 3,4)
register_food_item("italian_food:sunflowerolio",S("Sunflower Oil"), "italian_food_sunfloweroil.png", 5, 3)
register_food_item("italian_food:olive_oil",S("Olive Oil"), "italian_food_olive_oil.png", 7, 4)
register_food_item("italian_food:pork_jowl",S("Pork Jowl"), "italian_food_pork_jowl.png", 5, 3)

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
awards.register_achievement("italian_food:pizza_eating_100", {
	title = S("Are you a turtle from New York?"),
	icon = "italian_food_pizza.png",
	description = S("Eat 100 pizza slices."),
	trigger = {
		type = "eat",
		item= "italian_food:pizza",
		target = 100,
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
awards.register_achievement("italian_food:lasagna_eating", {
	title = S("Approved by a Famous Cat!"),
	icon = "italian_food_lasagna.png",
	description = S("Eat 100 Lasagna."),
	trigger = {
		type = "eat",
		item = "italian_food:lasagna",
		target = 100,
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
minetest.register_tool("italian_food:iron_rolling_pin", {
    description = S("Iron Rolling Pin"),
    inventory_image = "italian_food_iron_rolling_pin.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {times = {[1] = 1.2, [2] = 0.7, [3] = 0.3}, uses = 60, maxlevel = 2},
        },
        damage_groups = {fleshy = 2},
    },
    groups = {metal_tool = 1},
})
minetest.register_tool("italian_food:pizza_cutter_wheel", {
    description = S("Pizza Cutter"),
    inventory_image = "italian_food_cutter_wheel.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {times = {[1] = 1.2, [2] = 0.7, [3] = 0.3}, uses = 90, maxlevel = 3},
        },
        damage_groups = {fleshy = 5},
    },
    groups = {metal_tool = 1},
})

--cheese rack WIP
local S = minetest.get_translator("italian_food")
local CHEESE_TIME = 30
local function get_formspec(progress)
    local percent = math.floor(progress * 100)
    return ([[
        size[8,9]
        label[0,0;Sheep Milk → Cheese]
        list[current_name;input;2,1;1,1;]
        image[3.5,1;1,1;gui_furnace_arrow_bg.png^[lowpart:%d:gui_furnace_arrow_fg.png]
        list[current_name;output;5,1;2,1;]
        list[current_player;main;0,5;8,4;]
        background[-0.19,-0.25;8.4,9.75;gui_formbg.png;true]
    ]]):format(percent)
end

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
        meta:set_int("last_percent", -1)
        meta:set_string("infotext", "Cheese Rack (empty)")
        meta:set_string("formspec", get_formspec(0))
    end,

    on_rightclick = function(pos, node, clicker)
        local meta = minetest.get_meta(pos)
        minetest.show_formspec(clicker:get_player_name(),
            "italian_food:cheese_rack", meta:get_string("formspec"))
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
            meta:set_string("formspec", get_formspec(0))
            return false 
        end

        timer = timer + elapsed
        local progress = timer / CHEESE_TIME
        if progress > 1 then progress = 1 end

        if timer >= CHEESE_TIME then
            if inv:room_for_item("output", "italian_food:sheep_cheese") and
               inv:room_for_item("output", "mcl_buckets:bucket_empty") then

                inv:add_item("output", "italian_food:sheep_cheese")
                inv:add_item("output", "mcl_buckets:bucket_empty")
                input_stack:take_item()
                inv:set_stack("input", 1, input_stack)
                timer = 0
                progress = 0
            end
        end

        meta:set_int("cheese_time", timer)

        local percent = math.floor(progress * 100)
        local last = meta:get_int("last_percent")
        if math.abs(percent - last) >= 5 then
            meta:set_int("last_percent", percent)
            meta:set_string("formspec", get_formspec(progress))
        end

        meta:set_string("infotext", string.format("Cheese Rack (fermenting... %d%%)", percent))
        return true
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
            meta:set_string("formspec", get_formspec(0))
        end
    end,
})


-- potion idea
mcl_potions.register_potion({
   name = "sugar_coffee",
   _id_override = "italian_food:sugar_coffee",
   desc_suffix = S("of Sugar Coffee"),
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

-- music parappa rapa papara 
mcl_jukebox.register_record("tarantella", "Unknown", "tarantella", "mcl_jukebox_record_tarantella.png", "tarantella")
mcl_jukebox.register_record("tarantella_b", "Unknown", "b", "mcl_jukebox_record_benni.png", "b")


-- Hey doesn't tiramisu also use coffee and eggs? >;p         Inspired by a real dessert and a caffeine-fueled coding session!
