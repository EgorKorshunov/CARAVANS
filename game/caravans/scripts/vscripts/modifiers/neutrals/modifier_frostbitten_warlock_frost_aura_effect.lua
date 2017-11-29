modifier_frostbitten_warlock_frost_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura_effect:OnCreated( kv )
	if IsServer() then
		self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
		self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	end
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura_effect:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.attack_slow
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura_effect:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.movement_slow_percentage
end

--------------------------------------------------------------------------------
