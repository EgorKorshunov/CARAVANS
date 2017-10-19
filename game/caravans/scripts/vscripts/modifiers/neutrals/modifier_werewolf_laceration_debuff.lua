
modifier_werewolf_laceration_debuff = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:OnCreated( kv )
	self.extra_damage_income_percentage = self:GetAbility():GetSpecialValueFor( "extra_damage_income_percentage" )
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetEffectName()
	return "particles/items2_fx/sange_maim_d.vpcf"
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:OnAttackLanded(params) 
	if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetModifierIncomingPhysicalDamage_Percentage(params) 
	if IsServer() then
		if not self:GetParent():IsIllusion() and self.attack_record == params.record then 
			return self.extra_damage_income_percentage
		end 
	end
end

--------------------------------------------------------------------------------
