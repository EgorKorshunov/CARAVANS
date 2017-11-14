if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_hunchback_mage_fire_wave = thisEntity:FindAbilityByName("hunchback_mage_fire_wave")
	thisEntity:SetContextThink( "jungle_creep_hunchback_mage_think", ThinkHunchbackMage , 0.1)
end

function ThinkHunchbackMage()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_hunchback_mage_fire_wave:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_CLOSEST, 
						  false)

		if #targets > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]	
				CastFireWave( randomTarget )
		end
	end	
	

	return 1
end

function CastFireWave( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = ABILITY_hunchback_mage_fire_wave:entindex(),
		Queue = false,
	})
	return 1.0
end