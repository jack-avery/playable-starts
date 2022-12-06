dofile("mods/playable-starts/files/loadout.lua")
dofile("data/scripts/perks/perk.lua")

function OnPlayerSpawned(player_entity)
	local init_check_flag = "start_loadouts_init_done"
	if GameHasFlagRun(init_check_flag) then
		return
	end
	GameAddFlagRun(init_check_flag)

	local inventory = nil

	-- find the quick inventory
	local player_child_entities = EntityGetAllChildren(player_entity)
	if (player_child_entities ~= nil) then
		for i, child_entity in ipairs(player_child_entities) do
			local child_entity_name = EntityGetName(child_entity)

			if (child_entity_name == "inventory_quick") then
				inventory = child_entity
			end
		end
	end

	-- set inventory contents
	if (inventory ~= nil) then
		local inventory_items = EntityGetAllChildren(inventory)

		-- remove default items
		if inventory_items ~= nil then
			for i, item_entity in ipairs(inventory_items) do
				GameKillInventoryItem(player_entity, item_entity)
			end
		end

		-- add loadout items
		local loadout_items = loadout.items
		for item_id, loadout_item in ipairs(loadout_items) do
			if (tostring(type(loadout_item)) ~= "table") then
				local item_entity = EntityLoad(loadout_item)
				EntityAddChild(inventory, item_entity)
			else
				local amount = loadout_item.amount or 1

				for i = 1, amount do
					local item_option = ""

					if (loadout_item.options ~= nil) then
						local item_options = loadout_item.options
						local item_options_rnd = Random(1, #item_options)

						item_option = item_options[item_options_rnd]
					else
						item_option = loadout_item[1]
					end

					local item_entity = EntityLoad(item_option)
					if item_entity then
						EntityAddChild(inventory, item_entity)
					end
				end
			end
		end
	end
end
