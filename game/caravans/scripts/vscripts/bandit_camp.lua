if IsClient() then return end
require('timers')

function Spawn(entityKeyValues)

	thisEntity:SetHullRadius(80)


	
	Timers:CreateTimer(0.01,function()
		thisEntity:AddNewModifier(thisEntity,nil,"modifier_bandit_camp",nil)


	end)

end