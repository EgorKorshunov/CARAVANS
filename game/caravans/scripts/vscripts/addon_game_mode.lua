require('timers')

if Caravans == nil then
	Caravans = class({})
	_G.Caravans = Caravans
end

CaravanUnitTable = {}
_G.CaravanUnitTable = CaravanUnitTable

LinkLuaModifier("modifier_presents","modifier_presents.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_caravan","modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawnpoint","modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostivus_aura","modifiers",LUA_MODIFIER_MOTION_NONE)

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "models/courier/donkey_trio/mesh/donkey_trio.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.Caravans = Caravans()
	Caravans:InitGameMode()
end

function Caravans:InitGameMode()

	self.presents = 30 
	self.presentsMin = 10
	self.presentDissappearTime = 10





    ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(Caravans, "OnStateChange"),self)

    ListenToGameEvent("player_connect_full",Dynamic_Wrap(Caravans, "OnFullConnected"),self)
    ListenToGameEvent('player_chat', Dynamic_Wrap(Caravans, 'OnPlayerChat'), self)
    --ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Caravans, 'OnPlayerPickHero'), self)

    ListenToGameEvent("npc_spawned",Dynamic_Wrap(Caravans, "OnNpcSpawned"),self)


	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	--GameRules:SetPreGameTime(180)
	GameRules:SetPreGameTime(10)
	GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)



	curwp = 2
	waypoints = {}
	for i=1,25 do
		waypoints[i] = Entities:FindByName(nil,"wp"..i):GetOrigin()
	end
	--DeepPrintTable(waypoints)


	--[[local distance = 0
	local prev = wp1
	for i=2,25 do
		distance = distance + (waypoints[i]-prev):Length2D()
		prev = waypoints[i]
	end
	print(distance)]]

	--local startwp = Entities:FindByName(nil,"wp2")
    --local test = CreateUnitByName("npc_dota_creep_goodguys_melee",startwp:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
    
    --test:SetInitialGoalEntity(startwp)
end


function Caravans:OnNpcSpawned(t)
	local spawnedentity = EntIndexToHScript(t.entindex)
	if spawnedentity:IsRealHero() then
		Caravans:OnHeroSpawned(spawnedentity)
	end
end

firstherospawned = false
function Caravans:OnHeroSpawned(hero)
	if not hero.spawned then
		hero:AddNewModifier(hero,nil,"modifier_frostivus_aura",{})
		hero.spawned = true
	end
	if not firstherospawned then
		Caravans:OnFirstHeroSpawn()
		firstherospawned = true
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

function Caravans:OnPlayerChat(event)
	if event.text == "dire" then
		PlayerResource:GetPlayer(event.playerid):SetTeam(DOTA_TEAM_BADGUYS)
		PlayerResource:GetSelectedHeroEntity(event.playerid):SetTeam(DOTA_TEAM_BADGUYS)
	elseif event.text == "radiant" then
		PlayerResource:GetPlayer(event.playerid):SetTeam(DOTA_TEAM_GOODGUYS)
		PlayerResource:GetSelectedHeroEntity(event.playerid):SetTeam(DOTA_TEAM_GOODGUYS)
	end
	
end
	

function Caravans:DropPresent(attacker,target)
	--if self.presents > 0 then
		--self.presents = self.presents - 1


		local item = CreateItem("item_present",nil,nil)
		CreateItemOnPositionForLaunch(target:GetAbsOrigin(),item)
		if attacker:GetRangeToUnit(target) > 300 then
			pos = target:GetAbsOrigin() 
				+ 300*(attacker:GetAbsOrigin()-target:GetAbsOrigin()):Normalized() 
				+ RandomVector(RandomInt(-100,100))
		else
			pos = attacker:GetAbsOrigin() + RandomVector(RandomInt(-100,100))
		end
		item:LaunchLoot(false,250,0.5,pos)
	--end
end 

function PickupPresent(event)
	local hero = event.caster
	--hero:RemoveItem(event.ability)
	hero.presents = (hero.presents or 0) + 1
	print(hero.presents)

	hero:RemoveModifierByName("modifier_presents")
	hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
end



function Caravans:OnFirstHeroSpawn()
	Caravans:InitSpawnPoints()
end

function Caravans:InitSpawnPoints()
	SetTeamCustomHealthbarColor(5,63,18,110)
	for i=1,4 do
		spawnpointabs = Entities:FindByName(nil,"spawn_" .. i):GetOrigin()
		local spawnpoint = CreateUnitByName("spawnpoint",spawnpointabs,false,nil,nil,5)
		spawnpoint:AddNewModifier(spawnpoint,nil,"modifier_spawnpoint",{})
		spawnpoint.number = i
		Caravans:CreateTotemsParticles(spawnpoint,false)
	end
end

partorigins = {
	part_1 = Vector(-220,220,70),
	part_2 = Vector(-4,268,70),
	part_3 = Vector(212,140,70),
	part_4 = Vector(228,-76,70),
	part_5 = Vector(92,-252,70),
	part_6 = Vector(-148,-228,70),
	part_7 = Vector(-276,-20,70),
}

function Caravans:CreateTotemsParticles(spawnpoint,fast)
	local number = 1
	Timers:CreateTimer(10,function()
			local part = ParticleManager:CreateParticle("particles/respawntotem.vpcf",PATTACH_ABSORIGIN,spawnpoint)
			local abs = spawnpoint:GetAbsOrigin()
			ParticleManager:SetParticleControl(part,0,abs + partorigins[tostring("part_" .. number)])
			ParticleManager:SetParticleControlForward(part,0,Vector(0,0,1))
			spawnpoint[tostring("part_" .. number)] = part
			number = number + 1
			if number <= 7 then
				if not fast then
		      		return 1
		      	else
		      		return 0.05
		      	end
		    else
		    	Caravans:DestroyTotemParticle(spawnpoint,false)
		    	return nil
		    end
   	end)
end

function Caravans:DestroyTotemParticle(spawnpoint,fast)
	local number = 1
	Timers:CreateTimer(5,function()
			if spawnpoint[tostring("part_" .. number)] then
				ParticleManager:DestroyParticle(spawnpoint[tostring("part_" .. number)],false)
				spawnpoint[tostring("part_" .. number)] = nil
			end
			number = number + 1
			if number <= 7 then
				if not fast then
		      		return 1
		      	else
		      		return 0.05
		      	end
		    else
		    	return nil
		    end
   	end)
end



--[[ Evaluate the state of the game
function Caravans:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end]]



function Caravans:OnStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		local caravanunits = 1
		local firstcreep = CreateUnitByName("npc_dota_caravan_unit",waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
		firstcreep:AddNewModifier(firstcreep,nil,"modifier_caravan",{})
		CaravanUnitTable[caravanunits] = firstcreep
		
		firstcreep:SetContextThink("AI",CaravanAI,0.5)
		firstcreep.caravanID = caravanunits

		
		Timers:CreateTimer(2,function()
				caravanunits = caravanunits + 1
				
				local caravanunit = CreateUnitByName("npc_dota_caravan_unit",waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
				caravanunit:AddNewModifier(caravanunit,nil,"modifier_caravan",{})
				CaravanUnitTable[caravanunits] = caravanunit
				
				caravanunit.caravanID = caravanunits

				caravanunit:SetContextThink("AI",CaravanAI,0.5)
    		
    		if caravanunits < 5 then
      			return 1.5
      		else
      			return nil
      		end
    	end
  		)
	end
end

findrange = 700
function CaravanAI(unit)
	local CanMove = true

	local IsEnemyInRange = #FindUnitsInRadius(DOTA_TEAM_BADGUYS,
								unit:GetAbsOrigin(),
								nil,
								findrange,
								DOTA_UNIT_TARGET_TEAM_FRIENDLY,
								DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
								FIND_ANY_ORDER,
								false) ~= 0

	if IsEnemyInRange then
		CanMove = false
	end

	local previousUnit = CaravanUnitTable[unit.caravanID+1]
	if previousUnit and unit:GetRangeToUnit(previousUnit) > 200 then
		CanMove = false
	end

	local nextUnit = CaravanUnitTable[unit.caravanID-1]
	if nextUnit and unit:GetRangeToUnit(nextUnit) < 140 then
		CanMove = false
	end

	

	if unit.caravanID == 1 then
		local distanceToWayPoint = (unit:GetAbsOrigin() - waypoints[curwp]):Length2D()

		if distanceToWayPoint < 25 then
			curwp = curwp + 1
		end

		if CanMove then
			--print(curwp,waypoints[curwp])
			unit:MoveToPosition(waypoints[curwp])
		else
			unit:Stop()
		end
	else
		if CanMove then
			--print(CaravanUnitTable,CaravanUnitTable[unit.caravanID-1],unit.caravanID)
			unit:MoveToPosition(CaravanUnitTable[unit.caravanID-1]:GetAbsOrigin())
		else
			unit:Stop()
		end
	end


	return 0.1
end




