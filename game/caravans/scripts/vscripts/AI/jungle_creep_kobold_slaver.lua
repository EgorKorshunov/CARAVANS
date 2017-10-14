if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_kobold_lash = thisEntity:FindAbilityByName("kobold_lash")
	thisEntity:SetContextThink( "kobold_slaver_think", Think , 0.1)
end

function Think()
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
		if #targets ~= 0 then
			randomTarget = targets[RandomInt(1,#targets)]
			if string.find(randomTarget:GetUnitName(),"jungle_creep_kobold_slave_basic") and randomTarget:GetHealthPercent() > 20 then
				thisEntity:CastAbilityOnTarget(randomTarget, ABILITY_kobold_lash, -1)
			end
		end
	end	
	
	return 2
end