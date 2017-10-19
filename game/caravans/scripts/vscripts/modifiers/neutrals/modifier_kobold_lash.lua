modifier_kobold_lash = class({})

--------------------------------------------------------------------------------

function modifier_kobold_lash:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:OnCreated( kv )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movespeed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_percentage" )
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok_ovr_energy.vpcf"
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_percentage
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------