
modifier_black_human_bear_endurance_aura = class({})

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:GetModifierAura()
	return "modifier_black_human_bear_endurance_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

