white_human_bear_crush = class({})
LinkLuaModifier( "modifier_white_human_bear_crush", "modifiers/neutrals/modifier_white_human_bear_crush.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function white_human_bear_crush:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	
	if hTarget:TriggerSpellAbsorb(self) then
		return 
	end

	local stun_duration = self:GetSpecialValueFor( "stun_duration" ) 
	local slow_duration = self:GetSpecialValueFor( "slow_duration" ) 
	local crush_damage = self:GetSpecialValueFor( "crush_damage" ) 

	local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = crush_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

	ApplyDamage( damage )
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_white_human_bear_crush", { duration = slow_duration } )
	EmitSoundOn( "n_creep_Ursa.Clap", hTarget ) 
end

--------------------------------------------------------------------------------
