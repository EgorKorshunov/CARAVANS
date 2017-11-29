
modifier_fatty_marmalade_slug_juicy_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura_effect:OnCreated( kv )
	if IsServer() then
		self.bonus_health_percentage = self:GetAbility():GetSpecialValueFor( "bonus_health_percentage" ) * 0.01
	end
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura_effect:GetModifierExtraHealthPercentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_health_percentage
end

--------------------------------------------------------------------------------
