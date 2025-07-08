minetest.register_craft({
    output = "italian_food:dough",
    recipe = {
        {"", "mcl_farming:wheat_item", ""}, 
        {"mcl_farming:wheat_item", "mcl_farming:wheat_item", "mcl_farming:wheat_item"}, --good
        {"", "mcl_farming:wheat_item", ""}, 
    },
})
minetest.register_craft({
    output = "italian_food:pizza",
    recipe = {
        {"", "italian_food:mozzarella", ""}, 
        {"italian_food:tomato_sauce", "italian_food:tomato_sauce", "italian_food:tomato_sauce"}, --good
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
minetest.register_craft({
    output = "italian_food:lasagna",
    recipe = {
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
        {"italian_food:tomato_sauce", "italian_food:tomato_sauce", "italian_food:tomato_sauce"}, --good
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
minetest.register_craft({
    output = "italian_food:mushroom_pizza",
    recipe = {
        {"", "mcl_mushrooms:mushroom_brown", ""},   --good
        {"", "italian_food:pizza", ""}, 
        {"", "", ""}, 
    },
})
minetest.register_craft({
	output = "italian_food:spaghetti",
	recipe = {
        {"", "italian_food:tomato_sauce", ""}, 
        {"", "italian_food:spaghetti_raw", ""}, --good
        {"", "", ""}, 
    },
})
minetest.register_craft({
	output = "italian_food:bruschetta",
	recipe = {
        {"", "italian_food:tomato", ""}, 
        {"", "mcl_farming:bread", ""}, --good
        {"", "", ""}, 
    },
})

minetest.register_craft({
    output = "italian_food:tiramisu",
    recipe = {
        {"mcl_cocoas:cocoa_beans", "mcl_core:sugar", "mcl_cocoas:cocoa_beans"},
		{"italian_food:coffee", "mcl_throwing:egg", "italian_food:coffee"},      -- good
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "italian_food:gnocco_raw",
    recipe = {
        {"", "mcl_farming:potato_item", ""},
        {"mcl_farming:potato_item", "mcl_farming:potato_item", "mcl_farming:potato_item"},      --good
        {"", "mcl_farming:potato_item", ""},
    },
})

minetest.register_craft({
    output = "italian_food:tomato_sauce",
    recipe = {
        {"","italian_food:tomato", ""},
        {"", "mcl_potions:water", ""},      --good
        {"", "", ""},
    },
})
minetest.register_craft({
    output = "italian_food:pesto_sauce",
    recipe = {
        {"","italian_food:basil", ""},
        {"", "mcl_potions:water", ""},      --good
        {"", "", ""},
    },
})
minetest.register_craft({
    output = "italian_food:sunflowerolio",
    recipe = {
        {"","mcl_flowers:sunflower", ""}, --good
        {"", "mcl_potions:water", ""},     
        {"", "", ""},
    },
})
minetest.register_craft({
    output = "italian_food:coffee",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", "mcl_potions:water", ""},      --good
        {"", "", ""},
    },
})
minetest.register_craft({
	type = "cooking",
	output = "italian_food:mozzarella",                                  --good
	recipe = "mcl_mobitems:milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
minetest.register_craft({
	type = "cooking",
	output = "italian_food:sheep_cheese",                                  --good
	recipe = "italian_food:sheep_milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
minetest.register_craft({
    output = "italian_food:ice_cream",
    recipe = {
        {"mcl_core:sugar","mcl_core:ice", "mcl_core:sugar"},
        {"", "mcl_cocoas:cocoa_beans", ""},      --good
        {"", "italian_food:cone", ""},
    },
})
minetest.register_craft({
    output = "italian_food:cone",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "mcl_mobitems:milk_bucket", ""},      --good
        {"", "mcl_throwing:egg", ""},
    },
})
minetest.register_craft({
    output = "italian_food:pandoro",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "italian_food:dough", ""},      --good
        {"", "mcl_throwing:egg", ""},
    },
})
minetest.register_craft({
    output = "italian_food:panettone",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", "italian_food:dough", ""},      --good
        {"", "mcl_throwing:egg", ""},
    },
})
minetest.register_craft({
    output = "italian_food:raviolo_raw",
    recipe = {
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
        {"italian_food:dough", "mcl_mobitems:beef", "italian_food:dough"},      --good
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
minetest.register_craft({
    output = "italian_food:cannoli",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", "italian_food:dough", ""},      --good
        {"", "mcl_throwing:egg", ""},
    },
})
