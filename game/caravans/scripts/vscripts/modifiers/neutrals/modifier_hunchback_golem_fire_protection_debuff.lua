
modifier_hunchback_golem_fire_protection_debuff = class({})

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:OnCreated( kv )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_slow
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:OnTooltip( params )
	return self.damage_per_second 
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection_debuff:OnIntervalThink()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_hunchback_footman_cripple_debuff") then
			self.damageToDeal = self.damage_per_second * 2
		else
			self.damageToDeal = self.damage_per_second
		end

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damageToDeal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
