
modifier_centaur_doc_life_transfer_attack_immunity = class({})

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:OnCreated( kv )
	if IsServer() then
		self.break_radius = self:GetAbility():GetSpecialValueFor( "break_radius" )
		self.health_percent_interrupt = self:GetAbility():GetSpecialValueFor( "health_percent_interrupt" ) 

		self.flail_animation = self:GetCaster():StartGesture(ACT_DOTA_VICTORY)

		self:StartIntervalThink( 0.2 )
		EmitSoundOn("Hero_Pugna.LifeDrain.Loop",self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:OnIntervalThink()
	if IsServer() then
		local castLifeTransfer = false
		self.healTransferAffectedAllies = FindUnitsInRadius(self:GetParent():GetTeam(), 
						  self:GetParent():GetOrigin(), 
						  nil, 
						  self.break_radius, 
						  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						  DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		for t,r in pairs(self.healTransferAffectedAllies) do
			if r:HasModifier("modifier_centaur_doc_life_transfer_heal") then 
				castLifeTransfer = true
			end
		end

		if castLifeTransfer == false or self:GetParent():GetHealthPercent() <= self.health_percent_interrupt then
			self:GetParent():InterruptChannel()
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveGesture(ACT_DOTA_VICTORY)
		StopSoundOn("Hero_Pugna.LifeDrain.Loop",self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_attack_immunity:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
