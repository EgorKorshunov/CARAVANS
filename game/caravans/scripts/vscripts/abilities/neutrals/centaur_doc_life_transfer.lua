centaur_doc_life_transfer = class({})
LinkLuaModifier("modifier_centaur_doc_life_transfer_attack_immunity", "modifiers/neutrals/modifier_centaur_doc_life_transfer_attack_immunity.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_centaur_doc_life_transfer_heal", "modifiers/neutrals/modifier_centaur_doc_life_transfer_heal.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function centaur_doc_life_transfer:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local start_radius = self:GetSpecialValueFor( "start_radius" ) 
		local duration = self:GetSpecialValueFor( "duration" ) 

		caster:AddNewModifier(caster,self,"modifier_centaur_doc_life_transfer_attack_immunity",nil)

		self.nearbyAllies = FindUnitsInRadius(caster:GetTeam(), 
						  caster:GetOrigin(), 
						  nil, 
						  start_radius, 
						  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		for k,v in pairs(self.nearbyAllies) do
			if v ~= caster then
				v:AddNewModifier(caster,self,"modifier_centaur_doc_life_transfer_heal",nil)
			end
		end
	end
end

function centaur_doc_life_transfer:OnChannelFinish(bInterrupted)
	if IsServer() then
		for k,v in pairs(self.nearbyAllies) do
			v:RemoveModifierByName("modifier_centaur_doc_life_transfer_heal")
		end	
		self:GetCaster():RemoveModifierByName("modifier_centaur_doc_life_transfer_attack_immunity")
	end
end