if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_harpy_thunder_strike = thisEntity:FindAbilityByName("harpy_thunder_strike")
	thisEntity:SetContextThink( "harpy_sorcerer_think", ThinkHarpySorcerer, 0.1)
end

function ThinkHarpySorcerer()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_harpy_thunder_strike:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  400, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		if #targets > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
			if not randomTarget:IsStunned() then
				CastThuhderStrike( randomTarget )
			end
		end
	end	
	
	return RandomFloat(1,5)
end

function CastThuhderStrike( hTarget )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = ABILITY_harpy_thunder_strike:entindex(),
		Queue = false,
	})
	return 1.0
end