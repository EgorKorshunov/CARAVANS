hunchback_footman_cripple = class({})
LinkLuaModifier( "modifier_hunchback_footman_cripple", "modifiers/neutrals/modifier_hunchback_footman_cripple.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hunchback_footman_cripple_debuff", "modifiers/neutrals/modifier_hunchback_footman_cripple_debuff.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hunchback_footman_cripple:GetIntrinsicModifierName()
	return "modifier_hunchback_footman_cripple"
end

--------------------------------------------------------------------------------
