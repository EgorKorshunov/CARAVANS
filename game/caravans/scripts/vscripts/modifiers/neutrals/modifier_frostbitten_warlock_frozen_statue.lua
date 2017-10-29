modifier_frostbitten_warlock_frozen_statue = class({})

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:OnCreated( kv )
	self.extra_damage_percentage = self:GetAbility():GetSpecialValueFor( "extra_damage_percentage" )
	self.kill_threshold_percent = self:GetAbility():GetSpecialValueFor( "kill_threshold_percent" )
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf"
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:GetModifierIncomingDamage_Percentage( params )
	return self.extra_damage_percentage
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:OnTakeDamage( params )
	if self:GetParent():GetHealthPercent() <= self.kill_threshold_percent then
		self:GetParent():Kill(self:GetAbility(),self:GetAbility():GetCaster())
	end
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:GetDisableHealing( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:OnTooltip( params )
	return self.kill_threshold_percent
end


--------------------------------------------------------------------------------

function modifier_frostbitten_warlock_frozen_statue:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,	
	}

	return state
end

--------------------------------------------------------------------------------
