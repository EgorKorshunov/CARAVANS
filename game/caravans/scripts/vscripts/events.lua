
function Caravans:OnHeroDied(t)
	local hero = EntIndexToHScript(t.entindex_killed)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),"ShowDeathScreen",{})
    if hero.presents >= 1 then
		for i=1,hero.presents do
			Caravans:DropPresent(hero,hero:GetAbsOrigin()+RandomVector(RandomInt(0,200)),RandomFloat(0.4,0.7))
		end

	    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
	    	Caravans:SetDirePresents(self.direPresents + hero.presents)
	    end
	end

    hero.presents = 0
end

function Caravans:OnEntityKilled(keys)
	local killed = EntIndexToHScript(keys.entindex_killed)

	if killed:IsRealHero() then
		Caravans:OnHeroDied(keys)
	end

	if killed.spawnPoint then
		Neutrals:OnDeath(killed)
	end

end

function Caravans:OnFirstHeroSpawn()
	Caravans:InitSpawnPoints()
end

function SpawnOnRandomTotem(hero)
	local random = RandomInt(1,4)
	local spawnpointabs = Entities:FindByName(nil,"spawn_" .. random):GetOrigin()
	FindClearSpaceForUnit(hero,spawnpointabs,true)
end

function SpawnOnSpawnPoint(hero)
	local spawnpointabs = Entities:FindByName(nil,"spawn_" .. hero.selectedspawnpoint):GetOrigin()
	FindClearSpaceForUnit(hero,spawnpointabs,true)
end

firstherospawned = false
function Caravans:OnHeroSpawned(hero)
	if not hero.spawned then
		hero:AddNewModifier(hero,nil,"modifier_frostivus_aura",{})
		hero.spawned = true
		hero.presents = 0
	end
	if not firstherospawned then
		Caravans:OnFirstHeroSpawn()
		firstherospawned = true
	end
	if not hero.selectedspawnpoint or hero.selectedspawnpoint == 0 then
		SpawnOnRandomTotem(hero)
	else
		SpawnOnSpawnPoint(hero)
	end
	hero.selectedspawnpoint = 0
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),"HideDeathScreen",{})
end

function Caravans:OnNpcSpawned(t)
	local spawnedentity = EntIndexToHScript(t.entindex)
	if spawnedentity:IsRealHero() then
		Caravans:OnHeroSpawned(spawnedentity)
	end
end

function Caravans:OnFullConnected(event)
	
end

function Caravans:OnPlayerPickHero(event)
	local hero = EntIndexToHScript(event.heroindex)

    local heroSelected = PlayerResource:GetSelectedHeroEntity(playerID)
    
    if heroSelected then --отсеиваем иллюзии
        return
    end

end

function Caravans:OnItemPickedUp(keys)
  	local unitEntity = nil
  	if keys.UnitEntitIndex then
    	unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  	elseif keys.HeroEntityIndex then
    	unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  	end
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	if itemEntity.spawn then
		itemEntity.spawn.heal = nil
	end
end

function Caravans:OnStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Caravans:StartSalvesSpawn()
		local caravanunits = 1
		local firstcreep = CreateUnitByName("npc_dota_caravan_unit",self.waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
		firstcreep:AddNewModifier(firstcreep,nil,"modifier_caravan",{})
		CaravanUnitTable[caravanunits] = firstcreep
		
		firstcreep:SetContextThink("AI",function(unit) return Caravans:CaravanAI(unit) end,0.5)
		firstcreep.caravanID = caravanunits

		Timers:CreateTimer(2,function()
				caravanunits = caravanunits + 1
				
				local caravanunit = CreateUnitByName("npc_dota_caravan_unit",self.waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
				caravanunit:AddNewModifier(caravanunit,nil,"modifier_caravan",{})
				CaravanUnitTable[caravanunits] = caravanunit
				
				caravanunit.caravanID = caravanunits

				caravanunit:SetContextThink("AI",function(unit) return Caravans:CaravanAI(unit) end,0.5)
    		
    		if caravanunits < 5 then
      			return 1.5
      		else
      			return nil
      		end
    	end
  		)
	end
end

function Caravans:OnPlayerChat(event)
	if event.text == "dire" then
		PlayerResource:GetPlayer(event.playerid):SetTeam(DOTA_TEAM_BADGUYS)
		PlayerResource:GetSelectedHeroEntity(event.playerid):SetTeam(DOTA_TEAM_BADGUYS)
	elseif event.text == "radiant" then
		PlayerResource:GetPlayer(event.playerid):SetTeam(DOTA_TEAM_GOODGUYS)
		PlayerResource:GetSelectedHeroEntity(event.playerid):SetTeam(DOTA_TEAM_GOODGUYS)
	end

	if event.text == "-kill" then
		PlayerResource:GetSelectedHeroEntity(event.playerid):ForceKill(false)
	end
	if StringStartsWith(event.text, "-") then
        local input = split(string.sub(event.text, 2, string.len(event.text)))
        local command = input[1]
  	end
end