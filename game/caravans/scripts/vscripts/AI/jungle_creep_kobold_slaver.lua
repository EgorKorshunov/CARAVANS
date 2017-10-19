if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_kobold_lash = thisEntity:FindAbilityByName("kobold_lash")
	thisEntity:SetContextThink( "kobold_slaver_think", ThinkKoboldSlaver , 0.1)
end

function ThinkKoboldSlaver()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_kobold_lash:IsFullyCastable() and not thisEntity:IsStunned() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  250, 
						  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  450, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		if #targets > 0 and #enemies > 0 then
			local randomTarget = targets[RandomInt(1,#targets)]
			if string.find(randomTarget:GetUnitName(),"jungle_creep_kobold_slave_basic") and (not randomTarget:HasModifier("modifier_kobold_lash")) and randomTarget:GetHealthPercent() > 20  then
				CastLash( randomTarget )
			end
		end
	end	
	
	return 1
end

function CastLash( hTarget )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = ABILITY_kobold_lash:entindex(),
		Queue = false,
	})
	return 1.0
end