hunchback_golem_fire_protection = class({})
LinkLuaModifier( "modifier_hunchback_golem_fire_protection", "modifiers/neutrals/modifier_hunchback_golem_fire_protection.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hunchback_golem_fire_protection_debuff", "modifiers/neutrals/modifier_hunchback_golem_fire_protection_debuff.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hunchback_golem_fire_protection:GetIntrinsicModifierName()
	return "modifier_hunchback_golem_fire_protection"
end

--------------------------------------------------------------------------------
