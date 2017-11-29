modifier_hunchback_mage_fire_wave_debuff = class({})

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:OnCreated( kv )
	if IsServer() then
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.magic_resist_reduction = self:GetAbility():GetSpecialValueFor( "magic_resist_reduction" )
	
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
		self:StartIntervalThink( 1 )	
	end
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_hunchback_mage_fire_wave_debuff:OnIntervalThink()
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

function modifier_hunchback_mage_fire_wave_debuff:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_reduction
end

--------------------------------------------------------------------------------

