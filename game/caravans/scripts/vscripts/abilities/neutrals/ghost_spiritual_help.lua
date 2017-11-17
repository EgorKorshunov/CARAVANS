ghost_spiritual_help = class({})
LinkLuaModifier("modifier_ghost_spiritual_help", "modifiers/neutrals/modifier_ghost_spiritual_help.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_spiritual_help_effect", "modifiers/neutrals/modifier_ghost_spiritual_help_effect.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function ghost_spiritual_help:GetIntrinsicModifierName()
	return "modifier_ghost_spiritual_help"
end

--------------------------------------------------------------------------------
