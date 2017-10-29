if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_centaur_joe_war_stomp = thisEntity:FindAbilityByName("centaur_joe_war_stomp")
	thisEntity:SetContextThink( "jungle_creep_centaur_joe_think", ThinkCentaurJoe , 0.1)
end

function ThinkCentaurJoe()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_centaur_joe_war_stomp:IsFullyCastable() and not thisEntity:IsStunned() then
		local targetCreeps = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  350, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		local targetHeroes = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  350, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)


		if #targetCreeps > 1 or #targetHeroes > 0 then
			CastWarStomp()
		end
	end	
	

	return 1
end

function CastWarStomp()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ABILITY_centaur_joe_war_stomp:entindex(),
		Queue = false,
	})
	return 1.0
end