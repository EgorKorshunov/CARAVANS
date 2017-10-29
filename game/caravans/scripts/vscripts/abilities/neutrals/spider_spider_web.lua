
spider_spider_web = class({})
LinkLuaModifier( "modifier_spider_spider_web", "modifiers/neutrals/modifier_spider_spider_web.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_spider_web_thinker", "modifiers/neutrals/modifier_spider_spider_web_thinker.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_spider_web_effect", "modifiers/neutrals/modifier_spider_spider_web_effect.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spider_spider_web:GetIntrinsicModifierName()
	return "modifier_spider_spider_web"
end

--------------------------------------------------------------------------------

