require('timers')
require('util')


if Caravans == nil then
	Caravans = class({})
	_G.Caravans = Caravans
end

require('neutrals')
require('events')
require('presents')


CARAVANS_RUNES_SPAWN_COST = 4
CARAVANS_RUNES_BUYBACK_COST = 10

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

	self.round = 0

	self.presentsInCaravan = 25 

	self.direPresents = 0
	--self.radiantPresents = 0

	self.direPresentsTotal = 0
	self.radiantPresentsTotal = 0

	self:ClientUpdatePresents()
	--self.presents = 30 
	--self.presentsMin = 10
	--self.presentDissappearTime = 10

	_G.CaravanUnitTable = {}

    ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(Caravans, "OnStateChange"),self)

    ListenToGameEvent("player_connect_full",Dynamic_Wrap(Caravans, "OnFullConnected"),self)
    ListenToGameEvent('player_chat', Dynamic_Wrap(Caravans, 'OnPlayerChat'), self)
    --ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Caravans, 'OnPlayerPickHero'), self)

    ListenToGameEvent("npc_spawned",Dynamic_Wrap(Caravans, "OnNpcSpawned"),self)
    ListenToGameEvent("entity_killed",Dynamic_Wrap(Caravans, "OnEntityKilled"),self)
    ListenToGameEvent("dota_item_picked_up",Dynamic_Wrap(Caravans, "OnItemPickedUp"),self)
  	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( Caravans, "FilterExecuteOrder" ), self )
  	CustomGameEventManager:RegisterListener("SelectSpawnPoint", Dynamic_Wrap(Caravans, 'SelectSpawnPoint'))
  	CustomGameEventManager:RegisterListener("BuyBack", Dynamic_Wrap(Caravans, 'RunesBuyBack'))

	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	--GameRules:SetPreGameTime(180)
	GameRules:SetPreGameTime(0)
	GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)

	self.curwp = 2
	self.waypoints = {}
	for i=1,25 do
		self.waypoints[i] = Entities:FindByName(nil,"wp"..i):GetOrigin()
	end

	Neutrals:Init()
end

function Caravans:PrepareToRound()
	self.round = self.round + 1

	self.preRoundTime = true
	
	if self.round ~= 1 then
		self.direPresentsTotal = self.direPresentsTotal + self.direPresents
		self.direPresents = 0
		self.radiantPresentsTotal = self.radiantPresentsTotal + self.presentsInCaravan
		self.presentsInCaravan = 25
		Caravans:ClientUpdatePresents()

		self.curwp = 2
		CaravanUnitTable[1]:MoveToPosition(self.waypoints[25]+Vector(700,-700,0))
		Timers:CreateTimer(9,
			function()
				for _,unit in pairs(CaravanUnitTable) do
					unit:RemoveSelf()
				end
			end
		)
	end

	Timers:CreateTimer(10,function() Caravans:SpawnCaravan() end)

	Timers:CreateTimer(60, function() Caravans:StartRound() end)
end

function Caravans:StartRound()
	self.preRoundTime = false
end

function Caravans:OnRoundEnd()
	if self.round == 3 then
		if self.radiantPresentsTotal > self.direPresentsTotal then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		else
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	else
		Caravans:PrepareToRound()
	end
end

function Caravans:SpawnCaravan()
	_G.CaravanUnitTable = {}

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

			if caravanunit.caravanID == 3 then
				local minimapIcon = CreateUnitByName("minimap_courier",Vector(0,0,0),false,nil,nil,5)
				minimapIcon:AddNewModifier(minimapIcon,nil,"modifier_spawnpoint",{})
				minimapIcon:FollowEntity(caravanunit,true)
			end 

			caravanunit:SetContextThink("AI",function(unit) return Caravans:CaravanAI(unit) end,0.5)
			
			if caravanunits < 5 then
	  			return 1.5
	  		else
	  			return nil
	  		end
		end
	)
end

function Caravans:CaravanAttacked(attacker,target)
	if self.presentsInCaravan > 0 then
		Caravans:DecrementCaravanPresents()
		Caravans:IncrementDirePresents()
		
		if attacker:GetRangeToUnit(target) > 300 then
			pos = target:GetAbsOrigin() 
				+ 300*(attacker:GetAbsOrigin()-target:GetAbsOrigin()):Normalized() 
				+ RandomVector(RandomInt(0,100))
		else
			pos = attacker:GetAbsOrigin() + RandomVector(RandomInt(0,100))
		end

		Caravans:DropPresent(target,pos,0.5)
	
	end
end 


function Caravans:SelectSpawnPoint(t)
	local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	if hero:CheckRunes(CARAVANS_RUNES_SPAWN_COST) then
		hero.selectedspawnpoint = t.number
	end
end
function Caravans:RunesBuyBack(t)
	local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	if hero:CheckRunes(CARAVANS_RUNES_BUYBACK_COST + CARAVANS_RUNES_SPAWN_COST) then
		hero:ModifyRunes(-CARAVANS_RUNES_BUYBACK_COST)
		hero:RespawnHero(true,false,true)
	end
end


function CDOTA_BaseNPC_Hero:ModifyRunes(amount)
	self.runes = self.runes + amount
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()),"RunesUpdate",{runes = self.runes})
end
function CDOTA_BaseNPC_Hero:CheckRunes(amount)
	if self.runes > amount then
		return true
	end
	return false
end


function Caravans:StartSalvesSpawn()
	Timers:CreateTimer(1,function()
			for i=1,12 do
				local spawnpoint = Entities:FindByName(nil,"heal_" .. i)
				if spawnpoint.heal == nil then
	              	local item = CreateItem("item_healing_salve_use", nil, nil)
	            	CreateItemOnPositionSync(spawnpoint:GetOrigin(),item)
	                item:SetPurchaseTime(0)
					spawnpoint.heal = item
					item.spawn = spawnpoint
				end
			end
		return 30
   	end)
end


function Caravans:InitSpawnPoints()
	for i=1,4 do
		local spawnpointabs = Entities:FindByName(nil,"spawn_" .. i):GetOrigin()
		local spawnpoint = CreateUnitByName("spawnpoint",spawnpointabs,false,nil,nil,5)
		spawnpoint:AddNewModifier(spawnpoint,nil,"modifier_spawnpoint",{})
		spawnpoint.number = i
		Caravans:CreateTotemsParticles(spawnpoint,false)
	end
end

function Caravans:CreateTotemsParticles(spawnpoint,fast)
	local number = 1
	Caravans:DestroyTotemParticle(spawnpoint,true)
	Timers:CreateTimer(0.1,function()
			local part = ParticleManager:CreateParticle("particles/respawntotem.vpcf",PATTACH_ABSORIGIN,spawnpoint)
			local abs = Entities:FindByName(nil,"spawnpart_"..number.."_"..spawnpoint.number):GetOrigin()
			ParticleManager:SetParticleControl(part,0,abs+Vector(0,0,70))
			ParticleManager:SetParticleControlForward(part,0,Vector(0,0,1))
			spawnpoint[tostring("part_" .. number)] = part
			number = number + 1
			if number <= 7 then
				if not fast then
		      		return 1
		      	else
		      		return 0.01
		      	end
		    else
		    	return nil
		    end
   	end)
end

function Caravans:DestroyTotemParticle(spawnpoint,fast)
	local number = 1
	Timers:CreateTimer(function()
			if spawnpoint[tostring("part_" .. number)] then
				ParticleManager:DestroyParticle(spawnpoint[tostring("part_" .. number)],false)
				spawnpoint[tostring("part_" .. number)] = nil
			end
			number = number + 1
			if number <= 7 then
				if not fast then
		      		return 1
		      	else
		      		return 0.01
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


findrange = 700
function Caravans:CaravanAI(unit)
	local CanMove = true

	local IsEnemyInRange = #FindUnitsInRadius(DOTA_TEAM_BADGUYS,
								unit:GetAbsOrigin(),
								nil,
								findrange,
								DOTA_UNIT_TARGET_TEAM_FRIENDLY,
								DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
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
		local currentWayPoint = self.waypoints[self.curwp]


		local distanceToWayPoint = (unit:GetAbsOrigin() - currentWayPoint):Length2D()

		if distanceToWayPoint < 25 then
			self.curwp = self.curwp + 1
		end

		if self.curwp == 26 then Caravans:OnRoundEnd() return end

		if CanMove then
			--print(curwp,waypoints[curwp])
			if self.preRoundTime then
				currentWayPoint = (self.waypoints[2] + self.waypoints[1])/2
			end
			unit:MoveToPosition(currentWayPoint)
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


	local radiantHeroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
								unit:GetAbsOrigin(),
								nil,
								300,
								DOTA_UNIT_TARGET_TEAM_FRIENDLY,
								DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
								FIND_ANY_ORDER,
								false)

	for _,hero in pairs(radiantHeroes) do
		if hero.presents and hero.presents > 0 then

			local dropTime = RandomFloat(0.4,0.7)
			local container = Caravans:DropPresent(hero,unit:GetAbsOrigin() + unit:GetForwardVector()*RandomInt(-30,30), dropTime,false)
			Timers:CreateTimer(dropTime,function() 
				container:GetContainedItem():RemoveSelf() 
				container:RemoveSelf() 
				Caravans:IncrementCaravanPresents()
				--print(Caravans.presentsInCaravan)
			end)

			hero.presents = hero.presents - 1
			hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
		end
	end


	return 0.1
end





function Caravans:FilterExecuteOrder( filterTable )
	local units = filterTable["units"]
	local order_type = filterTable["order_type"]
	local issuer = filterTable["issuer_player_id_const"]
	local abilityIndex = filterTable["entindex_ability"]
	local targetIndex = filterTable["entindex_target"]
	local x = tonumber(filterTable["position_x"])
	local y = tonumber(filterTable["position_y"])
	local z = tonumber(filterTable["position_z"])
	local point = Vector(x,y,z)
	local queue = filterTable["queue"] == 1
	if not units["0"] then
	    return true
	end
	if order_type == DOTA_UNIT_ORDER_GLYPH then
	    return false
	end
	if order_type == DOTA_UNIT_ORDER_BUYBACK then
		return true
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return false
	end
  	return true
end