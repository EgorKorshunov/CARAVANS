
modifier_fatty_marmalade_slug_jelly_mass = class({})

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:GetModifierAura()
	return "modifier_fatty_marmalade_slug_jelly_mass_effect"
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	if IsServer() then
		self:StartIntervalThink( 0.25 )
	end
end

--------------------------------------------------------------------------------

function modifier_fatty_marmalade_slug_jelly_mass:OnIntervalThink()
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage_per_second / 4,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

