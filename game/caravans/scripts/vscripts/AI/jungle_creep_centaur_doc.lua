if IsClient() then return end

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_centaur_doc_life_transfer = thisEntity:FindAbilityByName("centaur_doc_life_transfer")
	thisEntity:SetContextThink( "jungle_creep_centaur_doc_think", ThinkCentaurDoc , 0.1)
end

function ThinkCentaurDoc()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end
		
	if ABILITY_centaur_doc_life_transfer:IsFullyCastable() and not thisEntity:IsStunned() then
		local allies = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		local cast_spell = false

		for k,v in pairs(allies) do
			if v ~= thisEntity and v:GetHealthPercent() < 80 then
				cast_spell = true
			end
		end

		if cast_spell then
			CastLifeTransfer()
		end
	end	
	

	return 0.5
end

function CastLifeTransfer()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ABILITY_centaur_doc_life_transfer:entindex(),
		Queue = false,
	})
	return 1.0
end