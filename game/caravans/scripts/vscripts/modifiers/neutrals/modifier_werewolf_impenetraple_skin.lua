modifier_werewolf_impenetraple_skin = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:OnCreated( kv )
	self.attack_damage_reduction = self:GetAbility():GetSpecialValueFor( "attack_damage_reduction" )
end

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:OnAttackLanded(params) 
	if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end

--------------------------------------------------------------------------------

function modifier_werewolf_impenetraple_skin:GetModifierIncomingPhysicalDamage_Percentage(params) 
	if IsServer() then
		if not self:GetParent():IsIllusion() and self.attack_record == params.record and not self:GetParent():PassivesDisabled() then 
			return self.attack_damage_reduction
		end 
	end
end

--------------------------------------------------------------------------------
