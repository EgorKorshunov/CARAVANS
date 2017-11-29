modifier_hunchback_footman_cripple_debuff = class({})

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:OnCreated( kv )
	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple_debuff:OnDeath(params) 
	if params.unit == self:GetParent() then
		self:GetParent():AddNoDraw()
		local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
								  self:GetParent():GetOrigin(), 
								  nil, 
								  self.radius, 
								  DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
								  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
								  DOTA_UNIT_TARGET_FLAG_NONE, 
								  FIND_ANY_ORDER, 
								  false)

		for k,v in pairs (targets) do
			if v:HasModifier("modifier_hunchback_footman_cripple_debuff") then
				self.damageToDeal = self.damage * 2
			else
				self.damageToDeal = self.damage
			end
			local explosionDamage = {
						victim = v,
						attacker = self:GetParent(),
						damage = self.damageToDeal,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

			ApplyDamage(explosionDamage)
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_CUSTOMORIGIN, nil )
	--	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
	--	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 0.4, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOn("Hero_OgreMagi.Fireblast.Target",self:GetParent())
	end
end

--------------------------------------------------------------------------------
