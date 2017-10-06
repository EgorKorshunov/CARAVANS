guards_support_third_slot_damage_aura = class({})
LinkLuaModifier("modifier_guards_support_damage_aura_emitter","heroes\Guards\Support\guards_support_third_slot_damage_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guards_support_damage_aura_effect","heroes\Guards\Support\guards_support_third_slot_damage_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guards_support_damage_aura_effect_doubled","heroes\Guards\Support\guards_support_third_slot_damage_aura.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_banner_of_victory:GetIntrinsicModifierName()
	return "modifier_guards_support_damage_aura_emitter"
end

-------------------------------------------------------------------------------

modifier_guards_support_damage_aura_emitter = class({})

function modifier_guards_support_damage_aura_emitter:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_guards_support_damage_aura_emitter:IsHidden()
	return true 
end

function modifier_guards_support_damage_aura_emitter:IsPurgable()
	return false 
end


function modifier_guards_support_damage_aura_emitter:IsAura()
	return true
end

function modifier_guards_support_damage_aura_emitter:GetAuraRadius()
	return self.radius
end

function modifier_guards_support_damage_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_guards_support_damage_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_guards_support_damage_aura_emitter:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_guards_support_damage_aura_emitter:GetAuraDuration()
	return 1
end

function modifier_guards_support_damage_aura_emitter:GetModifierAura()
	return "modifier_guards_support_damage_aura_effect"
end

function modifier_guards_support_damage_aura_emitter:OnCreated(kv)
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

-----------------------------------------------------------------------------------------

modifier_guards_support_damage_aura_effect = class({})

function modifier_guards_support_damage_aura_effect:IsBuff()
	return true
end

function modifier_banner_of_victory_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
 
	return funcs
end

function modifier_banner_of_victory_aura_effect:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetAbility():GetOwner():HasModifier("modifier_guards_support_damage_aura_effect_doubled") then
		return self.damagePercentageBonus * 2
	elseif not self:GetAbility():GetOwner():HasModifier("modifier_guards_support_damage_aura_effect_doubled") and not self:GetAbility():IsCooldownReady() then
		return 0
	else
		return self.damagePercentageBonus 
	end
end

function modifier_banner_of_victory_aura_effect:OnCreated(kv)
	self.damagePercentageBonus = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
end

-----------------------------------------------------------------------------------------

modifier_guards_support_damage_aura_effect_doubled = class({})

function modifier_guards_support_damage_aura_effect_doubled:IsBuff()
	return true
end

function modifier_guards_support_damage_aura_effect_doubled:IsHidden()
	return false
end

function modifier_guards_support_damage_aura_effect_doubled:IsPurgable()
	return false 
end