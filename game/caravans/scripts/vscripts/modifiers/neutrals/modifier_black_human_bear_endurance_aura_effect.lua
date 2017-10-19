
modifier_black_human_bear_endurance_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE  
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:OnCreated( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("crit_chance")*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage_pct
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if self:GetParent():PassivesDisabled() then
			return 0.0
		end

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if self.pseudo:Trigger() then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_black_human_bear_endurance_aura_effect:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				EmitSoundOn( "DOTA_Item.Daedelus.Crit", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

