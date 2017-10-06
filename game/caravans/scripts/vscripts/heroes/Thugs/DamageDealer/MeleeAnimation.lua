require('timers')
LinkLuaModifier( "modifier_troll_melee_animation", "heroes/Thugs/DamageDealer/modifier_troll_melee_animation.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn(entityKeyValues)
Timers:CreateTimer(0.01,function()
	thisEntity:AddNewModifier(thisEntity,nil,"modifier_troll_melee_animation",nil)
	return nil
end)

end