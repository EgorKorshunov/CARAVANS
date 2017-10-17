white_human_bear_crush = class({})
LinkLuaModifier( "modifier_white_human_bear_crush", "abilities/neutrals/white_human_bear_crush.lua", LUA_MODIFIER_MOTION_NONE )

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

modifier_white_human_bear_crush = class({})

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:OnCreated( kv )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_slow_percentage
end


--------------------------------------------------------------------------------
