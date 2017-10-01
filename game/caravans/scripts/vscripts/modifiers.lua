if modifier_caravan == nil then
	modifier_caravan = class({})
end

function modifier_caravan:IsHidden()
	return true
end

function modifier_caravan:CheckState()
	local state = {
	--[MODIFIER_STATE_INVULNERABLE] 		= 		true,
	--[MODIFIER_STATE_UNSELECTABLE] 		= 		true,
	[MODIFIER_STATE_NO_HEALTH_BAR]		= 		true,
	--[MODIFIER_STATE_NO_UNIT_COLLISION]	=		true,
	[MODIFIER_STATE_MAGIC_IMMUNE]		=		true,
	--[MODIFIER_STATE_ATTACK_IMMUNE]		=		true,
	--[MODIFIER_STATE_PROVIDES_VISION]		=		true,
	}
	return state
end


function modifier_caravan:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_caravan:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_caravan:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_caravan:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_caravan:GetModifierProvidesFOWVision()
	return 1
end

function modifier_caravan:GetModifierMoveSpeed_AbsoluteMin()
	return 100
end

function modifier_caravan:GetModifierMoveSpeed_Limit()
	return 100
end

if IsServer() then

	function modifier_caravan:OnCreated()
		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
		self:StartIntervalThink(0.03)
	end


	function modifier_caravan:OnIntervalThink()
		if self:GetParent():IsIdle() then
			--print("idle")
			self:GetParent():RemoveGesture(ACT_DOTA_RUN)
			self:GetParent():StartGesture(ACT_DOTA_IDLE)
		else
			--print("moving")
			self:GetParent():RemoveGesture(ACT_DOTA_IDLE)
			self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_RUN,0.3)
		end
		return 0.03
	end

end

function modifier_caravan:OnAttackLanded(event)
	if self:GetParent() == event.target then
		Caravans:CaravanAttacked(event.attacker,event.target)
	end
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