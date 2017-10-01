if modifier_presents == nil then
	modifier_presents = class({})
end

function modifier_presents:IsDebuff()
	return true
end

function modifier_presents:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_presents:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_presents:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * -10
end


