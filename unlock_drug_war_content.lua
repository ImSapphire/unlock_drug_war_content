local SetTunable
local SetTunables
local RevertTunable
local RevertTunables
do
	local og_tunable_values = {}
	function SetTunable(tunable: number, type: string, value)
		assert(memory["write_"..type] ~= nil, "\""..type.."\" is an invalid type")
		if og_tunable_values[tunable] == nil then
			og_tunable_values[tunable] = memory["read_"..type](memory.script_global(262145 + tunable), type)
		end
		memory["write_"..type](memory.script_global(262145 + tunable), value)
	end
	function SetTunables(tunables: table)
		for k, v in tunables do
			SetTunable(v[1], v[2], v[3])
		end
	end
	function RevertTunable(tunable: number, type: string)
		if (og_value := og_tunable_values[tunable]) ~= nil then
			memory["write_"..type](memory.script_global(262145 + tunable), og_value)
			og_tunable_values[tunable] = nil
		end
	end
	function RevertTunables(tunables: table)
		for k, v in tunables do
			RevertTunable(v[1], v[2])
		end
	end
end

local function tunable_toggle(menu_name, command_names, help_text, tunables: table)
	return menu.my_root():toggle_loop(menu_name, command_names, help_text, function()
		SetTunables(tunables)
	end, function()
		RevertTunables(tunables)
	end)
end

tunable_toggle("Unlock 50 Car Garage", {}, "Unlocks the 50-car garage for purchase on www.dynasty8realestate.com.", {
	{32702, "byte", 1},
	{32688, "byte", 0},
})

tunable_toggle("Unlock Taxi Missions", {}, "", {
	{33770, "byte", 1},
})

tunable_toggle("Unlock \"G's Cache\" Collectables", {}, "", {
	{33790, "byte", 1}
})

local gun_van_tunables = {
	{33799, "byte", 1}
}
for i = 0, 29 do -- XM22_GUN_VAN_LOCATION_ENABLED_[0 to 29]
	table.insert(gun_van_tunables, {33800 + 1 + i, "byte", 1})
end
tunable_toggle("Unlock Gun Van", {}, "", gun_van_tunables)

local vehicles_toggle
vehicles_toggle=menu.my_root():toggle("Unlock Vehicles", {}, "", function(on)
	if on then
		vehicles_toggle.value = false
		menu.ref_by_path("Online>Enhancements>Disable Dripfeeding"):focus()
	end
end)
