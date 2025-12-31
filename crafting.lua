core.register_craft({
    output = "italian_food:dough",
    recipe = {
        {"", "mcl_farming:wheat_item", ""}, 
        {"mcl_farming:wheat_item", "mcl_farming:wheat_item", "mcl_farming:wheat_item"},
        {"", "mcl_farming:wheat_item", ""}, 
    },
})
core.register_craft({
    output = "italian_food:pizza",
    recipe = {
        {"", "italian_food:mozzarella", ""}, 
        {"italian_food:tomato_sauce", "italian_food:tomato_sauce", "italian_food:tomato_sauce"}, 
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
core.register_craft({
    output = "italian_food:lasagna",
    recipe = {
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
        {"italian_food:tomato_sauce", "italian_food:tomato_sauce", "italian_food:tomato_sauce"}, 
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
core.register_craft({
    output = "italian_food:mushroom_pizza",
    recipe = {
        {"", "mcl_mushrooms:mushroom_brown", ""},   
        {"", "italian_food:pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = "italian_food:spaghetti",
	recipe = {
        {"", "italian_food:tomato_sauce", ""}, 
        {"", "italian_food:spaghetti_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = "italian_food:bruschetta",
	recipe = {
        {"", "italian_food:tomato", ""}, 
        {"", "mcl_farming:bread", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = "italian_food:tomato_sauce_bruschetta",
	recipe = {
        {"", "italian_food:tomato_sauce", ""}, 
        {"", "italian_food:bruschetta", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = "italian_food:pesto_bruschetta",
	recipe = {
        {"", "italian_food:pesto_sauce", ""}, 
        {"", "italian_food:bruschetta", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = "italian_food:tiramisu",
    recipe = {
        {"mcl_cocoas:cocoa_beans", "mcl_core:sugar", "mcl_cocoas:cocoa_beans"},
		{"italian_food:coffee", "mcl_throwing:egg", "italian_food:coffee"},      
        {"", "", ""},
    },
})

core.register_craft({
    output = "italian_food:gnocco_raw",
    recipe = {
        {"", "mcl_farming:potato_item", ""},
        {"mcl_farming:potato_item", "mcl_farming:potato_item", "mcl_farming:potato_item"},      
        {"", "mcl_farming:potato_item", ""},
    },
})

core.register_craft({
    output = "italian_food:tomato_sauce",
    recipe = {
        {"","italian_food:tomato", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = "italian_food:pesto_sauce",
    recipe = {
        {"","italian_food:basil", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = "italian_food:sunflowerolio",
    recipe = {
        {"","mcl_flowers:sunflower", ""}, 
        {"", "mcl_potions:glass_bottle", ""},     
        {"", "", ""},
    },
})
core.register_craft({
    output = "italian_food:olive_oil",
    recipe = {
        {"","italian_food:olive", ""}, 
        {"", "mcl_potions:glass_bottle", ""},     
        {"", "", ""},
    },
})
core.register_craft({
    output = "italian_food:coffee",
    recipe = {
        {"","italian_food:coffee_roasted_bean", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = "italian_food:sugar_coffee",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "italian_food:coffee", ""},      
        {"", "", ""},
    },
})
core.register_craft({
	type = "cooking",
	output = "italian_food:mozzarella",                                 
	recipe = "mcl_mobitems:milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
core.register_craft({
	type = "cooking",
	output = "italian_food:sheep_cheese",                                
	recipe = "italian_food:sheep_milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
core.register_craft({
	type = "cooking",
	output = "italian_food:coffee_roasted_bean",                                
	recipe = "italian_food:coffee_bean",
})
core.register_craft({
    output = "italian_food:ice_cream",
    recipe = {
        {"mcl_core:sugar","mcl_core:ice", "mcl_core:sugar"},
        {"", "mcl_cocoas:cocoa_beans", ""},      
        {"", "italian_food:cone", ""},
    },
})
core.register_craft({
    output = "italian_food:cone",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "mcl_mobitems:milk_bucket", ""},      
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = "italian_food:pandoro",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "italian_food:dough", ""},     
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = "italian_food:panettone",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", "italian_food:dough", ""},    
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = "italian_food:raviolo_raw",
    recipe = {
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
        {"italian_food:dough", "mcl_mobitems:beef", "italian_food:dough"},
        {"italian_food:dough", "italian_food:dough", "italian_food:dough"}, 
    },
})
core.register_craft({
    output = "italian_food:cannoli",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", "italian_food:dough", ""},
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = "italian_food:diamond_tomato",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "italian_food:tomato", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})
core.register_craft({
    output = "italian_food:diamond_basil",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "italian_food:basil", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})

-- non-food items
core.register_craft({
    output = "italian_food:rolling_pin",
    recipe = {
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""},
    },
})
core.register_craft({
    output = "italian_food:iron_rolling_pin",
    recipe = {
        {"", "mcl_core:iron_nugget", ""},
        {"", "mcl_core:iron_ingot", ""},
        {"", "mcl_core:iron_nugget", ""},
    },
})
core.register_craft({
    output = "italian_food:pizza_cutter_wheel",
    recipe = {
        {"mcl_core:iron_ingot", "", ""},
        {"", "mcl_core:stick", ""},
        {"", "", "mcl_core:stick"},
    },
})
core.register_craft({
    output = "italian_food:coffee_sack",
    recipe = {
        {"", "mcl_mobitems:string", ""},
        {"italian_food:coffee_roasted_bean", "italian_food:coffee_roasted_bean", "italian_food:coffee_roasted_bean"},
        {"italian_food:coffee_roasted_bean", "italian_food:coffee_roasted_bean", "italian_food:coffee_roasted_bean"},
    }
})

--olive wood stuff
core.register_craft({
	output = "italian_food:olivewood 4",
	recipe = {{"italian_food:olivetree"}},
})

core.register_craft({
	output = "italian_food:olivewood 4",
	recipe = {{"italian_food:stripped_olivetree"}},
})

core.register_craft({
	output = "italian_food:olivewood 3",
	recipe = {{"italian_food:olivetree_bark"}},
})

core.register_craft({
	output = "italian_food:olivewood 3",
	recipe = {{"italian_food:stripped_olivetree_bark"}},
})

core.register_craft({
	output = "mcl_stairs:slab_olivewood 6",
	recipe = {
		{"italian_food:olivewood", "italian_food:olivewood", "italian_food:olivewood"},
	}
})

core.register_craft({
	output = "mcl_stairs:stair_olivewood 4",
	recipe = {
		{"italian_food:olivewood", "", ""},
		{"italian_food:olivewood", "italian_food:olivewood", ""},
		{"italian_food:olivewood", "italian_food:olivewood", "italian_food:olivewood"},
	}
})
