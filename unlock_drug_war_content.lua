local SetTunable
local RevertTunable
do
	local og_tunable_values = {}
	function SetTunable(tunable: number, type: string, value)
		assert(memory["write_"..type] ~= nil, "\""..type.."\" is an invalid type")
		if og_tunable_values[tunable] == nil then
			og_tunable_values[tunable] = memory["read_"..type](memory.script_global(262145 + tunable), type)
		end
		memory["write_"..type](memory.script_global(262145 + tunable), value)
	end
	function RevertTunable(tunable: number, type: string)
		if (og_value := og_tunable_values[tunable]) ~= nil then
			memory["write_"..type](memory.script_global(262145 + tunable), og_value)
			og_tunable_values[tunable] = nil
		end
	end
end

util.create_tick_handler(function()
	if not SCRIPT_CAN_CONTINUE then return end
	SetTunable(32702, "byte", 1)
	SetTunable(32688, "byte", 0)
	SetTunable(33770, "byte", 1) -- XM22_TAXI_DRIVER_ENABLE
	SetTunable(33790, "byte", 1) -- COLLECTABLES_DEAD_DROP
	SetTunable(33799, "byte", 1) -- XM22_GUN_VAN_AVAILABLE
	for i = 0, 29 do -- XM22_GUN_VAN_LOCATION_ENABLED_[0 to 29]
		SetTunable(33800 + 1 + i, "byte", 1)
	end
	for i = 33957, 34112 do -- -- 33957 to 33972 is ENABLE_VEHICLE_*, others are clothing
		SetTunable(i, "byte", 1)
	end
end)

util.on_stop(function()
	RevertTunable(32702, "byte")
	RevertTunable(32688, "byte")
	RevertTunable(33770, "byte") -- XM22_TAXI_DRIVER_ENABLE
	RevertTunable(33790, "byte") -- COLLECTABLES_DEAD_DROP
	RevertTunable(33799, "byte") -- XM22_GUN_VAN_AVAILABLE
	for i = 0, 29 do -- XM22_GUN_VAN_LOCATION_ENABLED_[0 to 29]
		RevertTunable(33800 + 1 + i, "byte")
	end
	for i = 33957, 34112 do -- -- 33957 to 33972 is ENABLE_VEHICLE_*, others are clothing
		RevertTunable(i, "byte")
	end
end)