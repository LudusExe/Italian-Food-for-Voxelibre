local S = minetest.get_translator("italian_food")

local function on_bone_meal(itemstack,placer,pointed_thing,pos,node)
    plant_series = nil
    if string.find(node.name,"tomato_plant") then
        plant_series = "plant_tomato"
    elseif string.find(node.name,"basil_plant") then
        plant_series = "plant_basil"
    end
    return mcl_farming.on_bone_meal(itemstack,placer,pointed_thing,pos,node,plant_series)
end

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

local sel_heights = {
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
}

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

local sel_heights = {
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
    -5/16,
}

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