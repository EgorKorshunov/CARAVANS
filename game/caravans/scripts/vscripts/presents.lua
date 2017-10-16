function Caravans:DropPresent(unitFrom,posTo,dropTime,visible) 
	local item = CreateItem("item_present",nil,nil)
	local container = CreateItemOnPositionForLaunch(unitFrom:GetAbsOrigin(),item)
	item:LaunchLoot(false,RandomInt(150,300),dropTime,posTo)

	if visible == nil then
		visible = true
	end

	if visible then
		vision = function(container) 
				AddFOWViewer(DOTA_TEAM_BADGUYS,container:GetAbsOrigin(), 16, 1, false)
				AddFOWViewer(DOTA_TEAM_GOODGUYS,container:GetAbsOrigin(), 16, 1, false)
				return 0.5
			end

		container:SetContextThink("Vision",vision,1)
	end

	return container
end

function Caravans:PickupPresent(hero)
	hero.presents = (hero.presents or 0) + 1
	print(hero:GetUnitName().." have "..tostring(hero.presents).." presents")

	--[[if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		Caravans:IncrementDirePresents()
	end]]

	--hero:RemoveModifierByName("modifier_presents")
	hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
end

function Caravans:ClientUpdatePresents()
		CustomNetTables:SetTableValue("caravan","Presents",
		{ 
			direPresents = self.direPresents,
			presentsInCaravan = self.presentsInCaravan,
			direPresentsTotal = self.direPresentsTotal,
			radiantPresentsTotal = self.radiantPresentsTotal
		}
	)
end

function Caravans:IncrementCaravanPresents()
	self.presentsInCaravan = self.presentsInCaravan + 1
	self:ClientUpdatePresents()
end

function Caravans:DecrementCaravanPresents()
	self.presentsInCaravan = self.presentsInCaravan - 1

    if self.direPresents < 0 then
    	print("[CARAVANS] Caravan have "..self.presentsInCaravan.." presents")
    end

	self:ClientUpdatePresents()
end

function Caravans:IncrementDirePresents()
	self.direPresents = self.direPresents + 1
	self:ClientUpdatePresents()
end

function Caravans:DecrementDirePresents()
    self.direPresents = self.direPresents - 1
    
    if self.direPresents < 0 then
    	print("[CARAVANS] Dire have "..self.direPresents.." presents")
    end

	self:ClientUpdatePresents()
end


function Caravans:SetDirePresents(n)
	self.direPresents = n
	self:ClientUpdatePresents()
end