if modifier_caravan == nil then
	modifier_caravan = class({})
end

function modifier_caravan:IsHidden()
	return true
end
function modifier_caravan:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] 		= 		true,
	[MODIFIER_STATE_UNSELECTABLE] 		= 		true,
	[MODIFIER_STATE_NO_HEALTH_BAR]		= 		true,
	[MODIFIER_STATE_NO_UNIT_COLLISION]	=		true,
	[MODIFIER_STATE_MAGIC_IMMUNE]		=		true,
	[MODIFIER_STATE_ATTACK_IMMUNE]		=		true,
	}
	return state
end






if modifier_frostivus_aura == nil then
	modifier_frostivus_aura = class({})
end
function modifier_frostivus_aura:IsHidden()
	return false
end
function modifier_frostivus_aura:GetTexture()
	return "cake"
end
function modifier_frostivus_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_frostivus_aura:OnCreated()
	if IsServer() then
		Timers:CreateTimer(1,function()
				self:GetCaster():AddExperience(5,0,false,false)
	      	return 1
	   	end)
	end
end


modifier_spawnpoint = class({})
function modifier_spawnpoint:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }
    return funcs
end
function modifier_spawnpoint:CheckState()
  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    [MODIFIER_STATE_PROVIDES_VISION] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }

  return state
end
function modifier_spawnpoint:GetAbsoluteNoDamageMagical()
  return 1
end
function modifier_spawnpoint:GetAbsoluteNoDamagePhysical()
  return 1
end
function modifier_spawnpoint:GetAbsoluteNoDamagePure()
  return 1
end
function modifier_spawnpoint:GetMinHealth()
  return 1
end
function modifier_spawnpoint:IsHidden()
    return true
end