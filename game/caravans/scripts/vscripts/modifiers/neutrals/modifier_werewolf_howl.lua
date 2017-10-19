modifier_werewolf_howl = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_howl:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:OnCreated( kv )
	self.bonus_max_health = self:GetAbility():GetSpecialValueFor( "bonus_max_health" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:GetModifierExtraHealthBonus( params )
	return self.bonus_max_health
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------