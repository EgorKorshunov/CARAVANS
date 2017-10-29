
modifier_frostbitten_warlock_frost_aura = class({})

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:GetModifierAura()
	return "modifier_frostbitten_warlock_frost_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frost_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

