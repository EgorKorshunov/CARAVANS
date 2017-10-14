kobold_lash = class({})
LinkLuaModifier( "modifier_kobold_lash", "abilities/neutrals/kobold_lash.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kobold_lash:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_ATTACK );
end

function kobold_lash:OnSpellStart()
	local health_reduction = self:GetSpecialValueFor( "health_reduction" ) 
	local duration = self:GetSpecialValueFor(  "duration" )
	local hTarget = self:GetCursorTarget()

	local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = health_reduction,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

	ApplyDamage( damage )
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_kobold_lash", { duration = duration } )
	EmitSoundOn( "Hero_Dazzle.Poison_Tick", hTarget )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_kobold_lash = class({})

--------------------------------------------------------------------------------

function modifier_kobold_lash:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:OnCreated( kv )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movespeed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_percentage" )
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetEffectName()
	return "particles/neutral_fx/thunder_lizard_frenzy.vpcf"
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_percentage
end

--------------------------------------------------------------------------------

function modifier_kobold_lash:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------