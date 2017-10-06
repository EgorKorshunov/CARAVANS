modifier_troll_melee_animation = class({})

function modifier_troll_melee_animation:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_troll_melee_animation:IsHidden()
	return true
end

function modifier_troll_melee_animation:IsPurgable()
	return false
end

function modifier_troll_melee_animation:RemoveOnDeath()
	return false
end

function modifier_troll_melee_animation:DeclareFunctions()
	local funcs = {
					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end


function modifier_troll_melee_animation:GetActivityTranslationModifiers()
--	if IsServer() then 
		return "melee"
--	end
end

