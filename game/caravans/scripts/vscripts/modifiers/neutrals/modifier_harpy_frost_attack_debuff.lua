
modifier_harpy_frost_attack_debuff = class({})

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:OnCreated( kv )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
	self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------


function modifier_harpy_frost_attack_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_slow_percentage
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_slow
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:OnTooltip( params )
	return self.damage_per_second 
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack_debuff:OnIntervalThink()
	if IsServer() then
		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_per_second,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
