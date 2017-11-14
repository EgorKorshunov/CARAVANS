
modifier_fatty_marmalade_slug_jelly_mass_effect = class({})

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass_effect:OnCreated( kv )
	self.movement_slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_naga_riptide.vpcf"
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass_effect:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass_effect:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.movement_slow
end

--------------------------------------------------------------------------------
