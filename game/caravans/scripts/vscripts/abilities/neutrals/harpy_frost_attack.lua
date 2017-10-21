
harpy_frost_attack = class({})
LinkLuaModifier( "modifier_harpy_frost_attack", "modifiers/neutrals/modifier_harpy_frost_attack.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_harpy_frost_attack_debuff", "modifiers/neutrals/modifier_harpy_frost_attack_debuff.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function harpy_frost_attack:GetIntrinsicModifierName()
	return "modifier_harpy_frost_attack"
end

--------------------------------------------------------------------------------
