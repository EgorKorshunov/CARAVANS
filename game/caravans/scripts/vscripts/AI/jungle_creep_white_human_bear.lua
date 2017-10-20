if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_white_human_bear_crush = thisEntity:FindAbilityByName("white_human_bear_crush")
	thisEntity:SetContextThink( "white_human_bear_think", ThinkWhiteHumanBear , 0.1)
end

function ThinkWhiteHumanBear()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_white_human_bear_crush:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  250, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		if #targets > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
			if not randomTarget:IsStunned()  then
				CastCrush( randomTarget )
			end
		end
	end	
	

	return 2
end

function CastCrush( hTarget )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = ABILITY_white_human_bear_crush:entindex(),
		Queue = false,
	})
	return 1.0
end