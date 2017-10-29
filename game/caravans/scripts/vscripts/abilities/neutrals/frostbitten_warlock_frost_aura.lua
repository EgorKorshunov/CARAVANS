frostbitten_warlock_frost_aura = class({})
LinkLuaModifier("modifier_frostbitten_warlock_frost_aura", "modifiers/neutrals/modifier_frostbitten_warlock_frost_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostbitten_warlock_frost_aura_effect", "modifiers/neutrals/modifier_frostbitten_warlock_frost_aura_effect.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function frostbitten_warlock_frost_aura:GetIntrinsicModifierName()
	return "modifier_frostbitten_warlock_frost_aura"
end

--------------------------------------------------------------------------------
