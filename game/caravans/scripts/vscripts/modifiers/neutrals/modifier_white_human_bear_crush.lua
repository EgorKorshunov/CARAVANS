
modifier_white_human_bear_crush = class({})

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_white_human_bear_crush:IsPurgable()
	return false
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
