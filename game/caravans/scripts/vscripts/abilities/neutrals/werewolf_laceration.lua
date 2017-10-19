
werewolf_laceration = class({})
LinkLuaModifier( "modifier_werewolf_laceration", "modifiers/neutrals/modifier_werewolf_laceration.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_werewolf_laceration_debuff", "modifiers/neutrals/modifier_werewolf_laceration_debuff.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function werewolf_laceration:GetIntrinsicModifierName()
	return "modifier_werewolf_laceration"
end

--------------------------------------------------------------------------------
