harpy_thunder_strike = class({})

--------------------------------------------------------------------------------

function harpy_thunder_strike:OnSpellStart()
	local lightning_damage = self:GetSpecialValueFor( "lightning_damage" ) 
	local stun_duration = self:GetSpecialValueFor(  "stun_duration" )
	local hTarget = self:GetCursorTarget()

	local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = lightning_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

	ApplyDamage( damage )
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
	local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
	local loc = hTarget:GetAbsOrigin()
	ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
	ParticleManager:SetParticleControl(lightning, 1, loc)
	ParticleManager:SetParticleControl(lightning, 2, loc)
	EmitSoundOn( "Hero_Zuus.LightningBolt", hTarget )
end
