
modifier_ghost_spiritual_help = class({})

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:GetModifierAura()
	return "modifier_ghost_spiritual_help_effect"
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

