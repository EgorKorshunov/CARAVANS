modifier_spiderling_poison_explosion = class({})

--------------------------------------------------------------------------------

function modifier_spiderling_poison_explosion:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiderling_poison_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiderling_poison_explosion:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_spiderling_poison_explosion:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_spiderling_poison_explosion:OnDeath(params) 
	if params.unit == self:GetParent() then
		self:GetParent():AddNoDraw()
		local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
								  self:GetParent():GetOrigin(), 
								  nil, 
								  self.radius, 
								  DOTA_UNIT_TARGET_TEAM_ENEMY, 
								  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
								  DOTA_UNIT_TARGET_FLAG_NONE, 
								  FIND_ANY_ORDER, 
								  false)

		for k,v in pairs (targets) do
			local explosionDamage = {
						victim = v,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

			ApplyDamage(explosionDamage)
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius / 2, 0.4, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOn("Hero_Broodmother.SpawnSpiderlings",self:GetParent())
	end
end

--------------------------------------------------------------------------------
