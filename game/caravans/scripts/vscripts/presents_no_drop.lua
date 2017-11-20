function OnStartTouch(trigger)
	local ent = trigger.activator
	ent:AddNewModifier(trigger.activator, nil, "modifier_lia_presents_no_drop", nil)
end

LinkLuaModifier("modifier_lia_presents_no_drop", "modifier_lia_presents_no_drop.lua" ,LUA_MODIFIER_MOTION_NONE)

modifier_lia_presents_no_drop = class({})

function modifier_lia_presents_no_drop:IsHidden()
	return true
end
