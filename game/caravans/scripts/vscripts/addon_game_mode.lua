require('timers')
require('util')
require('PseudoRandom')

if Caravans == nil then
	Caravans = class({})
	_G.Caravans = Caravans
end

require('neutrals')
require('events')
require('presents')


LinkLuaModifier("modifier_presents","modifier_presents.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_caravan","modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawnpoint","modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostivus_aura","modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bandit_camp","modifier_bandit_camp.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drop_presents","modifiers/modifier_drop_presents.lua",LUA_MODIFIER_MOTION_NONE)

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "models/courier/donkey_trio/mesh/donkey_trio.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
  	PrecacheItemByNameSync("item_healing_salve_use", context)
  	PrecacheUnitByNameAsync("jungle_creep_centaur_doc" , function(...) end)
  	PrecacheUnitByNameAsync("jungle_creep_centaur_bob" , function(...) end)
  	PrecacheUnitByNameAsync("jungle_creep_centaur_joe" , function(...) end)
  	PrecacheUnitByNameAsync("jungle_creep_werewolf_chieftain" , function(...) end)
  	PrecacheUnitByNameAsync("jungle_creep_werewolf" , function(...) end)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)	
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)	
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_broodmother.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context)
  	PrecacheResource("particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf", context)
  	PrecacheResource("particle", "particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf", context)
  	PrecacheResource("particle", "particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6.vpcf", context)
  	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context)
  	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf", context)
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

	self.checkPoints = {12,21}
	self.checkPointsTime = 240
	self.checkPointCampTime = 1
	self.stopDropPresents = false

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

	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	--GameRules:SetPreGameTime(180)
	GameRules:SetPreGameTime(0)
	--GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:SetGoldTickTime(0.4)
    GameRules:SetCustomGameSetupRemainingTime(15)
	GameRules:SetCustomGameSetupAutoLaunchDelay(3)

	self.curwp = 2
	self.waypoints = {}
	local i = 1
	while true do
		local wp = Entities:FindByName(nil,"wp"..i)
		if wp then
			self.waypoints[i] = wp:GetOrigin()
		else
			print("[CARAVANS] Found "..i.." waypoints")
			break
		end
		i = i + 1
	end

	self.banditCamps = {}
	local camp = Entities:FindByModel(nil,"models/tent/bandit_camp_large.vmdl")
	if camp then table.insert(self.banditCamps,camp) end
	
	camp = nil
	while true do
		camp = Entities:FindByModel(camp,"models/tent/bandit_camp.vmdl")
		if camp then 
			table.insert(self.banditCamps,camp) 
		else 
			break 
		end
	end


	Neutrals:Init()
end

function Caravans:PrepareToRound()
	self.round = self.round + 1

	self.preRoundTime = true
	
	if self.round ~= 1 then
		
		CaravanUnitTable[1]:MoveToPosition(self.waypoints[#self.waypoints])
		Timers:CreateTimer(14,
			function()
				for _,unit in pairs(CaravanUnitTable) do
					unit:RemoveSelf()
					self.curwp = 2
					self.stopDropPresents = false
				end
			end
		)

	end

	Timers:CreateTimer(15,function() Caravans:SpawnCaravan() end)

	Timers:CreateTimer(60, function() Caravans:StartRound() end)
	self.roundStartTime = GameRules:GetDOTATime(false,false) + 60
	Caravans:ClientsUpdateInfo()
end

function StartDropPresents()

	func = function() 
		local donkey = CaravanUnitTable[5]
		local dropPos = donkey:GetAbsOrigin() - donkey:GetForwardVector()*300

		if self.stopDropPresents then
			return 60
		end
		
		if Caravans.presentsInCaravan > 0 then
			Caravans:DecrementCaravanPresents()
			Caravans:IncrementDirePresents()
			Caravans:DropPresent(donkey,dropPos,0.5,true) 
		end

		return 5
	end

	Timers:CreateTimer("CaravanDropPresents", {
		endTime = 5,
		callback = func
	})
end

function Caravans:StartRound()
	self.preRoundTime = false

	Timers:CreateTimer("CaravanCheckPoint", {
			endTime = self.checkPointsTime,
			callback = StartDropPresents
		})
	self.nextCheckPointTime = GameRules:GetDOTATime(false,false) + self.checkPointsTime

	self:ClientsUpdateInfo()
end

function Caravans:OnRoundEnd()
	Timers:RemoveTimer("CaravanDropPresents")
	Timers:RemoveTimer("CaravanCheckPoint")

	self.direPresentsTotal = self.direPresentsTotal + self.direPresents
	self.direPresents = 0
	self.radiantPresentsTotal = self.radiantPresentsTotal + self.presentsInCaravan
	self.presentsInCaravan = 25
	Caravans:ClientUpdatePresents()

	local containers = Entities:FindAllByClassname("dota_item_drop")
    for _,container in pairs(containers) do
        item = container:GetContainedItem()
        if item and item:GetAbilityName() == "item_present" then
            container:RemoveSelf()
            item:RemoveSelf()
        end
    end

    local heroes = HeroList:GetAllHeroes()
    for _,hero in pairs(heroes) do
    	hero.presents = 0
    	hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
    end

    for _,camp in pairs(self.banditCamps) do
    	camp.presents = 0
    end

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

function Caravans:BanditCampAttacked(attacker,target)
	if target.presents and target.presents > 0 then
		target.presents = target.presents - 1

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
	hero.selectedspawnpoint = t.number
end


function Caravans:StartSalvesSpawn()
	Timers:CreateTimer(60,function()
			for i=1,12 do
				local spawnpoint = Entities:FindByName(nil,"heal_" .. i)
				if spawnpoint.heal == nil then
	              	local item = CreateItem("item_healing_salve_use", nil, nil)
	                item:SetPurchaseTime(0)
	            	CreateItemOnPositionSync(spawnpoint:GetOrigin(),item)
					spawnpoint.heal = item
					item.spawn = spawnpoint
				end
			end
		return 60
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

function Caravans:CaravanCamp()
	self.IsCaravanCamping = true
	Timers:RemoveTimer("CaravanDropPresents")
	Timers:RemoveTimer("CaravanCheckPoint")
	Timers:CreateTimer(self.checkPointCampTime, 
		function() 
			self.IsCaravanCamping = false 

			Timers:CreateTimer("CaravanCheckPoint", {
				endTime = self.checkPointsTime,
				callback = StartDropPresents
			})

			self.nextCheckPointTime = GameRules:GetDOTATime(false,false) + self.checkPointsTime
			Caravans:ClientsUpdateInfo()
		end)

	self.campEndTime = GameRules:GetDOTATime(false,false) + self.checkPointCampTime
	Caravans:ClientsUpdateInfo()
end


findrange = 700
function Caravans:CaravanAI(unit)


	table.sort(CaravanUnitTable,function(a,b) 
		return DistanceBetweenPoints(a:GetAbsOrigin(),self.waypoints[self.curwp]) < DistanceBetweenPoints(b:GetAbsOrigin(),self.waypoints[self.curwp])
	end)

    for i=1,5 do
    	if CaravanUnitTable[i] then
    		CaravanUnitTable[i].caravanID = i
    	end
    end

	local CanMove = not self.IsCaravanCamping



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
	if previousUnit and unit:GetRangeToUnit(previousUnit) > 200  then
		CanMove = false
	end

	local nextUnit = CaravanUnitTable[unit.caravanID-1]
	if nextUnit then
		if unit:GetRangeToUnit(nextUnit) < 140 then
			CanMove = false
		end

		if unit:GetRangeToUnit(nextUnit) > 220 then
			CanMove = true
		end

	end

	if unit.caravanID == 1 then
		local currentWayPoint = self.waypoints[self.curwp]


		local distanceToWayPoint = (unit:GetAbsOrigin() - currentWayPoint):Length2D()
		
		if distanceToWayPoint < 25 then
			if self.curwp == self.checkPoints[1] or self.curwp == self.checkPoints[2] then
				Caravans:CaravanCamp()
			end

			self.curwp = self.curwp + 1
			if self.curwp == 31 then self.stopDropPresents = true end
			if self.curwp == #self.waypoints then Caravans:OnRoundEnd() return end

		end
		

		if CanMove then
			--print(curwp,waypoints[curwp])
			if self.preRoundTime then
				currentWayPoint = self.waypoints[2]
				distanceToWayPoint = (unit:GetAbsOrigin() - currentWayPoint):Length2D()
				if distanceToWayPoint > 10 then
					unit:MoveToPosition(currentWayPoint)
				end
			else
				unit:MoveToPosition(currentWayPoint)
			end
			
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
				Caravans:DecrementDirePresents()
				--print(Caravans.presentsInCaravan)
			end)

			hero.presents = hero.presents - 1
			hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
		end
	end
 
 	--DebugDrawText(unit:GetAbsOrigin(),tostring(DistanceBetweenPoints(unit:GetAbsOrigin(),self.waypoints[self.curwp])),true,0.2)
 	return 0.2
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

	local unit = EntIndexToHScript(units["0"])
	if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM  then
		local itemName = EntIndexToHScript(targetIndex):GetContainedItem():GetAbilityName()
		if itemName == "item_present" then
			if unit:IsRealHero() then 
				if unit.presents > 3 then
					SendErrorMessage(unit:GetPlayerOwnerID(), "#error_max_presents")
					return false
				end
			else
				SendErrorMessage(unit:GetPlayerOwnerID(), "#unit_cant_pickup_presents")
				return false
			end
		end
	end




  	return true
end

function Caravans:ClientsUpdateInfo()
	CustomNetTables:SetTableValue("caravan","Timer",
		{ 
			preRoundTime = self.preRoundTime,
			roundStartTime = self.roundStartTime,
			IsCaravanCamping = self.IsCaravanCamping,
			campEndTime = self.campEndTime,
			nextCheckPointTime = self.nextCheckPointTime,
		})
end