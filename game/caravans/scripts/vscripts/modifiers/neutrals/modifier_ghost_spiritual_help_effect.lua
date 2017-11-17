
modifier_ghost_spiritual_help_effect = class({})

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE  
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help_effect:OnCreated( kv )
	self.damage_reduction_percentage = self:GetAbility():GetSpecialValueFor( "damage_reduction_percentage" )
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_spiritual_help_effect:GetModifierIncomingPhysicalDamage_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.damage_reduction_percentage
end

--------------------------------------------------------------------------------

