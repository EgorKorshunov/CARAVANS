if modifier_caravan == nil then
	modifier_caravan = class({})
end

function modifier_caravan:IsHidden()
	return true
end
function modifier_caravan:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] 		= 		true,
	[MODIFIER_STATE_UNSELECTABLE] 		= 		true,
	[MODIFIER_STATE_NO_HEALTH_BAR]		= 		true,
	[MODIFIER_STATE_NO_UNIT_COLLISION]	=		true,
	[MODIFIER_STATE_MAGIC_IMMUNE]		=		true,
	[MODIFIER_STATE_ATTACK_IMMUNE]		=		true,
	}
	return state
end