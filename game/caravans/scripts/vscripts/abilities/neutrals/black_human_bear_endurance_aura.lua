black_human_bear_endurance_aura = class({})
LinkLuaModifier("modifier_black_human_bear_endurance_aura", "modifiers/neutrals/modifier_black_human_bear_endurance_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_human_bear_endurance_aura_effect", "modifiers/neutrals/modifier_black_human_bear_endurance_aura_effect.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function black_human_bear_endurance_aura:GetIntrinsicModifierName()
	return "modifier_black_human_bear_endurance_aura"
end

--------------------------------------------------------------------------------
