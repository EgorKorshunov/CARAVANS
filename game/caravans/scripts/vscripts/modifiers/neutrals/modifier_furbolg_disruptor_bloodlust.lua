modifier_furbolg_disruptor_bloodlust = class({})

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:OnCreated( kv )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movespeed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_percentage" )
	self.model_scale_percent = self:GetAbility():GetSpecialValueFor( "model_scale_percent" )
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_percentage
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

function modifier_furbolg_disruptor_bloodlust:GetModifierModelScale( params )
	return self.model_scale_percent
end

--------------------------------------------------------------------------------