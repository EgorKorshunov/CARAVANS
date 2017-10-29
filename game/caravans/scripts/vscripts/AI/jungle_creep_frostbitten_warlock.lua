if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_frostbitten_warlock_frozen_statue = thisEntity:FindAbilityByName("frostbitten_warlock_frozen_statue")
	thisEntity:SetContextThink( "frostbitten_warlock_frostbitten_warlock_think", ThinkFrostbittenWarlock , 0.1)
end

function ThinkFrostbittenWarlock()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_frostbitten_warlock_frozen_statue:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		if #targets > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
			if randomTarget:GetHealthPercent() < 40 or thisEntity:GetHealthPercent() < 25  then
				CastFrozenStatue( randomTarget )
			end
		end
	end	
	

	return 1
end

function CastFrozenStatue( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = ABILITY_frostbitten_warlock_frozen_statue:entindex(),
		Queue = false,
	})
	return 1.0
end