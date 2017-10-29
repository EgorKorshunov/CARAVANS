modifier_spider_spider_web_effect = class({})

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:OnCreated( kv )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movespeed_percentage = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_percentage" )
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:GetModifierMoveSpeedBonus_Percentage( params )
	if string.find(self:GetParent():GetUnitName(),"jungle_creep_spider") then
		return self.bonus_movespeed_percentage
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_effect:GetModifierAttackSpeedBonus_Constant( params )
	if string.find(self:GetParent():GetUnitName(),"jungle_creep_spider") then
		return self.bonus_attack_speed
	end
	return 0
end

--------------------------------------------------------------------------------