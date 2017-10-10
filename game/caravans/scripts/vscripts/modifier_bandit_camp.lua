if modifier_bandit_camp == nil then
	modifier_bandit_camp = class({})
end

function modifier_bandit_camp:IsHidden()
	return true
end

function modifier_bandit_camp:CheckState()
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


function modifier_bandit_camp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_bandit_camp:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_bandit_camp:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_bandit_camp:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_bandit_camp:GetModifierProvidesFOWVision()
	return 1
end


if IsServer() then

	function modifier_bandit_camp:OnCreated()
		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
		self:StartIntervalThink(0.1)
	end

end

function modifier_bandit_camp:OnAttackLanded(event)
	if self:GetParent() == event.target then
		Caravans:BanditCampAttacked(event.attacker,event.target)
	end
end


function modifier_bandit_camp:OnIntervalThink()
	local unit = self:GetParent()
	local direHeroes = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
								unit:GetAbsOrigin(),
								nil,
								300,
								DOTA_UNIT_TARGET_TEAM_FRIENDLY,
								DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
								FIND_ANY_ORDER,
								false)

	for _,hero in pairs(direHeroes) do
		if hero.presents and hero.presents > 0 then

			local dropTime = RandomFloat(0.4,0.7)
			local container = Caravans:DropPresent(hero,unit:GetAbsOrigin() + unit:GetForwardVector()*RandomInt(-30,30), dropTime,false)
			Timers:CreateTimer(dropTime,function() 
				container:GetContainedItem():RemoveSelf() 
				container:RemoveSelf() 
				unit.presents = (unit.presents or 0) + 1
			end)

			hero.presents = hero.presents - 1
			hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
		end
	end

	return 0.1
end