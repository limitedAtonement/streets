--[[
	StreetsMod: Create signs in the signworkshop
]]
minetest.register_node(":streets:signworkshop",{
	description = "Sign workshop",
	tiles = {},
	groups = {cracky = 1, level = 2},
	after_place_node = function(pos)
		minetest.get_meta(pos):set_string("formspec",table.concat({
			"size[12,10]",
			"label[3.5,0;Sign workshop - Create signs for your roads!]",
			"label[0,0.5;Available signs:]",
			"list[context;streets:signworkshop_list;0,1;5,4]",
			"label[9,0.5;Needed stuff:]",
			"list[context;streets:signworkshop_recipe;8,1;4,1]",
			"label[9,2;Put it here:]",
			"list[context;streets:signworkshop_input;8,3;4,1]",
			"button[8,4;2,1;streets:signworkshop_send;Start!]",
			"label[5.8,0.5;Selected:]",
			"list[context;streets:signworkshop_select;6,1;1,1]",
			"label[5.8,2.5;Output:]",
			"list[context;streets:signworkshop_output;6,3;1,1]",
			"list[current_player;main;2,6;8,4]",
		}))
		local inv = minetest.get_inventory({type = "node", pos = pos})
		inv:set_size("streets:signworkshop_list",5*4)
		inv:set_size("streets:signworkshop_recipe",3*2)
		inv:set_size("streets:signworkshop_input",4*1)
		inv:set_size("streets:signworkshop_select",1*1)
		inv:set_size("streets:signworkshop_output",1*1)
		-- Fill
		inv:add_item("streets:signworkshop_list","streets:sign_blank")
		inv:add_item("streets:signworkshop_list","streets:sign_lava")
		inv:add_item("streets:signworkshop_list","streets:sign_water")
		inv:add_item("streets:signworkshop_list","streets:sign_construction")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname ~= "streets:signworkshop_input" then
			return 0
		else
			return 1
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		-- Move items inside input slots
		if to_list == "streets:signworkshop_input" and from_list == "streets:signworkshop_input" then
			return 1
		-- List -> selection
		elseif from_list == "streets:signworkshop_list" and to_list == "streets:signworkshop_select" then
			local inv = minetest.get_meta(pos):get_inventory()
			local selected = inv:get_stack("streets:signworkshop_list",from_index):to_table()
			local need = minetest.registered_nodes[selected.name].streets.signworkshop.recipe
			inv:set_list("streets:signworkshop_recipe",{need[1],need[2],need[3],need[4]})
			return 1
		-- selection -> list
		elseif from_list == "streets:signworkshop_select" and to_list == "streets:signworkshop_list" then
			local inv = minetest.get_meta(pos):get_inventory()
			inv:set_list("streets:signworkshop_recipe",{"","","",""})
			return 1
		-- Every other case
		else
			return 0
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "streets:signworkshop_input" or listname == "streets:signworkshop_output" then
			return 99
		else
			return 0
		end
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local inv = minetest.get_inventory({type = "node", pos = pos})
		--
		if inv:is_empty("streets:signworkshop_input") ~= true and inv:is_empty("streets:signworkshop_select") ~= true then
			local selection = inv:get_stack("streets:signworkshop_select",1):get_name()
			local def = minetest.registered_nodes[selection].streets.signworkshop
			local need = inv:get_list("streets:signworkshop_recipe")
			local has = inv:get_list("streets:signworkshop_input")
			need[1] = need[1]:to_table()
			need[2] = need[2]:to_table()
			need[3] = need[3]:to_table()
			need[4] = need[4]:to_table()
			has[1] = has[1]:to_table()
			has[2] = has[2]:to_table()
			has[3] = has[3]:to_table()
			has[4] = has[4]:to_table()
			if need[1] == nil then need[1] = { name = "" } end
			if need[2] == nil then need[2] = { name = "" } end
			if need[3] == nil then need[3] = { name = "" } end
			if need[4] == nil then need[4] = { name = "" } end
			if has[1] == nil then has[1] = { name = "" } end
			if has[2] == nil then has[2] = { name = "" } end
			if has[3] == nil then has[3] = { name = "" } end
			if has[4] == nil then has[4] = { name = "" } end
			if need[1].name == has[1].name and need[2].name == has[2].name and need[3].name == has[3].name and need[4].name == has[4].name then
				minetest.chat_send_all("yay")
			end
		end
	end
})