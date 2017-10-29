if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_frostbitten_giant_ice_spikes = thisEntity:FindAbilityByName("frostbitten_giant_ice_spikes")
	thisEntity:SetContextThink( "jungle_creep_frostbitten_giant_think", ThinkFrostbittenGiant , 0.1)
end

function ThinkFrostbittenGiant()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_frostbitten_giant_ice_spikes:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  600, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_CLOSEST, 
						  false)

		if #targets > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
			if not randomTarget:IsStunned() then
				CastIceSpikes( randomTarget )
			end
		end
	end	
	

	return 1
end

function CastIceSpikes( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = ABILITY_frostbitten_giant_ice_spikes:entindex(),
		Queue = false,
	})
	return 1.0
end