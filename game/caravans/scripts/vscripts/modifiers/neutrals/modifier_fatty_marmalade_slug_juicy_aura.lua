
modifier_fatty_marmalade_slug_juicy_aura = class({})

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:GetModifierAura()
	return "modifier_fatty_marmalade_slug_juicy_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_juicy_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

