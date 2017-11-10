modifier_shrines_invisibility = class({})

--------------------------------------------------------------------------------

function modifier_shrines_invisibility:IsHidden()
	return true
end

-------------------------------------------------------------

function modifier_shrines_invisibility:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_shrines_invisibility:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_shrines_invisibility:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_shrines_invisibility:GetModifierPersistentInvisibility( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_shrines_invisibility:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
