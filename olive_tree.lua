local function olive_tree_init(S, modpath, biolib, italian_food)

    biolib.register_planks(
        "italian_food:olivewood",
        S("Olive Wood Planks"),
        {"italian_food_planks.png"}
    )

    biolib.register_wooden_stairs(
        "olivewood",
        "italian_food:olivewood",
        "italian_food_planks.png",
        S("Olive Wood Stairs"),
        S("Olive Wood Slab"),
        S("Olive Wood Double Slab")
    )

    biolib.register_wooden_fence(
        "olivewood",
        "italian_food:olivewood",
        S("Olive Wood Fence"),
        S("Olive Wood Fence Gate"),
        "italian_food_planks.png"
    )

    biolib.register_tree_trunk(
        "italian_food:olivetree",
        S("Olive Tree Log"),
        S("Olive Tree Bark"),
        S("The trunk of an olive tree."),
        "italian_food_olive_tree_top.png",
        "italian_food_olive_tree.png",
        "italian_food:stripped_olivetree"
    )

    biolib.register_stripped_trunk(
        "italian_food:stripped_olivetree",
        S("Stripped Olive Tree Log"),
        S("Stripped Olive Wood"),
        S("The stripped trunk of an olive tree."),
        S("The stripped wood of an olive tree."),
        "italian_food_olive_stripped_top.png",
        "italian_food_olive_stripped.png"
    )

    biolib.register_leaves(
        "italian_food:oliveleaves",
        S("Olive Tree Leaves"),
        S("Olive Tree leaves are grown from olive trees."),
        {"italian_food_olive_leaves.png"},
        "italian_food:olivesapling",
        {30, 25, 20, 15, 10},
        {"italian_food:olive", {150, 120, 90, 60, 30}}
    )

    biolib.register_sapling(
        "italian_food:olivesapling",
        S("Olive Sapling"),
        S("Grows into an olive tree under the right conditions."),
        S("Needs soil and light to grow."),
        "italian_food_olive_sapling.png",
        {-4/16, -0.5, -4/16, 4/16, 0.5, 4/16}
    )

    local olive_tree = {}

    function olive_tree.generate(pos)
        local i = math.random(1, 3)
        local path = modpath .. "/schematics/italian_food_olive_tree_" .. i .. ".mts"
        minetest.set_node(pos, {name="air"})
        return minetest.place_schematic(pos, path, "random", nil, true)
    end

    biolib.register_bonemeal_sapling("italian_food:olivesapling", function(pos)
        return olive_tree.generate(pos)
    end)
    local function olive_sapling_grow(pos)
        local i = math.random(1, 3)
        local path = modpath .. "/schematics/italian_food_olive_tree_" .. i .. ".mts"
        minetest.place_schematic(pos, path, "random", nil, true)
    end

    biolib.register_world_updates(
        {"italian_food:olivesapling"},
        {"group:soil_sapling"},
        "Olive tree growth",
        "Add growth for unloaded olive tree",
        "italian_food:lbm_olivetree",
        120, 4,
        olive_sapling_grow
    )

    for i = 1, 3 do
        minetest.register_decoration({
            deco_type = "schematic",
            place_on = {"group:soil_sapling"},
            sidelen = 16,
            fill_ratio = 0.00004,
            biomes = {},
            y_max = 100,
            y_min = 1,
            schematic = modpath .. "/schematics/italian_food_olive_tree_" .. i .. ".mts",
            flags = "place_center_x, place_center_z",
            rotation = "random",
        })
    end

    return olive_tree
end

return olive_tree_init