if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_frostbitten_shaman_frost_armor = thisEntity:FindAbilityByName("frostbitten_shaman_frost_armor")
	thisEntity:SetContextThink( "frostbitten_warlock_frostbitten_shaman_think", ThinkFrostbittenShaman , 0.1)
end

function ThinkFrostbittenShaman()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_frostbitten_shaman_frost_armor:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		if #targets > 0 and #enemies > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
			if not randomTarget:HasModifier("modifier_lich_frost_armor") then
				CastFrostShield( randomTarget )
			end
		end
	end	
	

	return 1
end

function CastFrostShield( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = ABILITY_frostbitten_shaman_frost_armor:entindex(),
		Queue = false,
	})
	return 1.0
end