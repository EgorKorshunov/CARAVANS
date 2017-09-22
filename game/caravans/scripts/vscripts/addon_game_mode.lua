require('timers')

if Caravans == nil then
	Caravans = class({})
	_G.Caravans = Caravans
end

_G.CaravanUnitTable = {}

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
	for i=1,25 do
		waypoints[i] = Entities:FindByName(nil,"wp"..i):GetOrigin()
	end


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
	if GameRules:State_Get() == 8 then

		runmapai()
		local caravanunits = 1
		local firstcreep = CreateUnitByName("npc_dota_caravan_unit",waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
		firstcreep:SetInitialGoalEntity(Entities:FindByName(nil,"wp1"))
		firstcreep:AddNewModifier(firstcreep,nil,"modifier_caravan",{})
		_G.CaravanUnitTable[caravanunits] = firstcreep
		Timers:CreateTimer(0.05, function()
					runai(caravanunits)
		      	return nil
		   	end
		)
		Timers:CreateTimer(1.5,function()
				caravanunits = caravanunits + 1
				local caravanunit = CreateUnitByName("npc_dota_caravan_unit",waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
				caravanunit:AddNewModifier(caravanunit,nil,"modifier_caravan",{})
				_G.CaravanUnitTable[caravanunits] = caravanunit
				Timers:CreateTimer(0.05, function()
							runai(caravanunits)
				      	return nil
				   	end
				)
    		if caravanunits < 5 then
      			return 1.5
      		else
      			return nil
      		end
    	end
  		)
	end
end


function runai(key)
	if key == 1 then
		ai1()
	elseif key == 2 then
		ai2()
	elseif key == 3 then
		ai3()
	elseif key == 4 then
		ai4()
	elseif key == 5 then
		ai5()
	end
end

AREFRIENDSHERE1 = false
AREFRIENDSHERE2 = false
AREFRIENDSHERE3 = false
AREFRIENDSHERE4 = false
AREFRIENDSHERE5 = false
AREENEMIESSHERE1 = false
AREENEMIESSHERE2 = false
AREENEMIESSHERE3 = false
AREENEMIESSHERE4 = false
AREENEMIESSHERE5 = false
enemies = false
friends = false
aretimerdown = false
findrange = 700
secstotimerdown = 20
damagein100ms = 1
healin100ms = 0.1
caravanhealth = 100

function ai1()
	Timers:CreateTimer(function()
			local goodheroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                            _G.CaravanUnitTable[1]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			local badheroes = 	FindUnitsInRadius(DOTA_TEAM_BADGUYS,
	                            _G.CaravanUnitTable[1]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			if #goodheroes > 0 then
				AREFRIENDSHERE1 = true
			else
				AREFRIENDSHERE1 = false
			end
			if #badheroes > 0 then
				AREENEMIESSHERE1 = true
			else
				AREENEMIESSHERE1 = false
			end
			if not _G.CaravanUnitTable[1]:IsNull() and _G.CaravanUnitTable[1]:IsAlive() then
				if _G.CaravanUnitTable[2] ~= nil and not _G.CaravanUnitTable[2]:IsNull() and _G.CaravanUnitTable[2]:IsAlive() then
					local distanceToWaypoint = (_G.CaravanUnitTable[1]:GetOrigin() - waypoints[curwp]):Length2D()
					local distanceToPreviousUnit = (_G.CaravanUnitTable[2]:GetOrigin() - _G.CaravanUnitTable[1]:GetOrigin()):Length2D()
					if distanceToPreviousUnit < 200 then
						if enemies == false and aretimerdown == false then
							if distanceToWaypoint > 10 then
								_G.CaravanUnitTable[1]:MoveToPosition(waypoints[curwp])
							elseif distanceToWaypoint <= 10 then
								curwp = curwp + 1
								_G.CaravanUnitTable[1]:MoveToPosition(waypoints[curwp])
							end
						else
							_G.CaravanUnitTable[1]:Stop()
						end
					else
						_G.CaravanUnitTable[1]:Stop()
					end
					--print("Current wp: " .. curwp .. " Distance to wp: " .. distanceToWaypoint)
		      	else
		      		_G.CaravanUnitTable[1]:MoveToPosition(waypoints[curwp])
		      	end
				if not _G.CaravanUnitTable[1]:IsNull() and _G.CaravanUnitTable[1]:IsAlive() then
	      			return 0.1
	      		else
	      			return nil
	      		end
	      	end
	   	end
	)
end

function ai2()
	local distanceToPreviousUnit
	Timers:CreateTimer(function()
			local goodheroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                            _G.CaravanUnitTable[2]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			local badheroes = 	FindUnitsInRadius(DOTA_TEAM_BADGUYS,
	                            _G.CaravanUnitTable[2]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			if #goodheroes > 0 then
				AREFRIENDSHERE2 = true
			else
				AREFRIENDSHERE2 = false
			end
			if #badheroes > 0 then
				AREENEMIESSHERE2 = true
			else
				AREENEMIESSHERE2 = false
			end
			if not _G.CaravanUnitTable[2]:IsNull() and _G.CaravanUnitTable[2]:IsAlive() then
				if _G.CaravanUnitTable[3] ~= nil and not _G.CaravanUnitTable[3]:IsNull() and _G.CaravanUnitTable[3]:IsAlive() then
					distanceToPreviousUnit = (_G.CaravanUnitTable[3]:GetOrigin() - _G.CaravanUnitTable[2]:GetOrigin()):Length2D()
				end
				local distanceToFrontUnit = (_G.CaravanUnitTable[1]:GetOrigin() - _G.CaravanUnitTable[2]:GetOrigin()):Length2D()
				if distanceToFrontUnit < 170 then
					_G.CaravanUnitTable[2]:Stop()
				elseif distanceToPreviousUnit ~= nil and distanceToPreviousUnit > 200 then
					_G.CaravanUnitTable[2]:Stop()
				elseif not _G.CaravanUnitTable[1]:IsNull() and _G.CaravanUnitTable[1]:IsAlive() then
					_G.CaravanUnitTable[2]:MoveToNPC(_G.CaravanUnitTable[1])
				end
				if not _G.CaravanUnitTable[2]:IsNull() and _G.CaravanUnitTable[2]:IsAlive() then
	      			return 0.1
	      		else
	      			return nil
	      		end
	      	end
	   	end
	)
end

function ai3()
	local distanceToPreviousUnit
	Timers:CreateTimer(function()
			local goodheroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                            _G.CaravanUnitTable[3]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			local badheroes = 	FindUnitsInRadius(DOTA_TEAM_BADGUYS,
	                            _G.CaravanUnitTable[3]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			if #goodheroes > 0 then
				AREFRIENDSHERE3 = true
			else
				AREFRIENDSHERE3 = false
			end
			if #badheroes > 0 then
				AREENEMIESSHERE3 = true
			else
				AREENEMIESSHERE3 = false
			end
			if not _G.CaravanUnitTable[3]:IsNull() and _G.CaravanUnitTable[3]:IsAlive() then
				if _G.CaravanUnitTable[4] ~= nil and not _G.CaravanUnitTable[4]:IsNull() and _G.CaravanUnitTable[4]:IsAlive() then
					distanceToPreviousUnit = (_G.CaravanUnitTable[4]:GetOrigin() - _G.CaravanUnitTable[3]:GetOrigin()):Length2D()
				end
				local distanceToFrontUnit = (_G.CaravanUnitTable[2]:GetOrigin() - _G.CaravanUnitTable[3]:GetOrigin()):Length2D()
				if distanceToFrontUnit < 170 then
					_G.CaravanUnitTable[3]:Stop()
				elseif distanceToPreviousUnit ~= nil and distanceToPreviousUnit > 200 then
					_G.CaravanUnitTable[3]:Stop()
				elseif not _G.CaravanUnitTable[2]:IsNull() and _G.CaravanUnitTable[2]:IsAlive() then
					_G.CaravanUnitTable[3]:MoveToNPC(_G.CaravanUnitTable[2])
				end
				if not _G.CaravanUnitTable[3]:IsNull() and _G.CaravanUnitTable[3]:IsAlive() then
	      			return 0.1
	      		else
	      			return nil
	      		end
	      	end
	   	end
	)
end

function ai4()
	local distanceToPreviousUnit
	Timers:CreateTimer(function()
			local goodheroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                            _G.CaravanUnitTable[4]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			local badheroes = 	FindUnitsInRadius(DOTA_TEAM_BADGUYS,
	                            _G.CaravanUnitTable[4]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			if #goodheroes > 0 then
				AREFRIENDSHERE4 = true
			else
				AREFRIENDSHERE4 = false
			end
			if #badheroes > 0 then
				AREENEMIESSHERE4 = true
			else
				AREENEMIESSHERE4 = false
			end
			if not _G.CaravanUnitTable[4]:IsNull() and _G.CaravanUnitTable[4]:IsAlive() then
				if _G.CaravanUnitTable[5] ~= nil and not _G.CaravanUnitTable[5]:IsNull() and _G.CaravanUnitTable[5]:IsAlive() then
					distanceToPreviousUnit = (_G.CaravanUnitTable[5]:GetOrigin() - _G.CaravanUnitTable[4]:GetOrigin()):Length2D()
				end
				local distanceToFrontUnit = (_G.CaravanUnitTable[3]:GetOrigin() - _G.CaravanUnitTable[4]:GetOrigin()):Length2D()
				if distanceToFrontUnit < 170 then
					_G.CaravanUnitTable[4]:Stop()
				elseif distanceToPreviousUnit ~= nil and distanceToPreviousUnit > 200 then
					_G.CaravanUnitTable[4]:Stop()
				elseif not _G.CaravanUnitTable[3]:IsNull() and _G.CaravanUnitTable[3]:IsAlive() then
					_G.CaravanUnitTable[4]:MoveToNPC(_G.CaravanUnitTable[3])
				end
				if not _G.CaravanUnitTable[4]:IsNull() and _G.CaravanUnitTable[4]:IsAlive() then
	      			return 0.1
	      		else
	      			return nil
	      		end
	      	end
	   	end
	)
end

function ai5()
	local distanceToPreviousUnit
	Timers:CreateTimer(function()
			local goodheroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                            _G.CaravanUnitTable[5]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			local badheroes = 	FindUnitsInRadius(DOTA_TEAM_BADGUYS,
	                            _G.CaravanUnitTable[5]:GetAbsOrigin(),
	                            nil,
	                            findrange,
	                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                            DOTA_UNIT_TARGET_HERO,
	                            DOTA_UNIT_TARGET_FLAG_NONE,
	                            FIND_ANY_ORDER,
	                            false)
			if #goodheroes > 0 then
				AREFRIENDSHERE5 = true
			else
				AREFRIENDSHERE5 = false
			end
			if #badheroes > 0 then
				AREENEMIESSHERE5 = true
			else
				AREENEMIESSHERE5 = false
			end
			if not _G.CaravanUnitTable[5]:IsNull() and _G.CaravanUnitTable[5]:IsAlive() then
				local distanceToFrontUnit = (_G.CaravanUnitTable[4]:GetOrigin() - _G.CaravanUnitTable[5]:GetOrigin()):Length2D()
				if distanceToFrontUnit < 170 then
					_G.CaravanUnitTable[5]:Stop()
				elseif not _G.CaravanUnitTable[4]:IsNull() and _G.CaravanUnitTable[4]:IsAlive() then
					_G.CaravanUnitTable[5]:MoveToNPC(_G.CaravanUnitTable[4])
				end
				if not _G.CaravanUnitTable[5]:IsNull() and _G.CaravanUnitTable[5]:IsAlive() then
	      			return 0.1
	      		else
	      			return nil
	      		end
	      	end
	   	end
	)
end

function runmapai()
	local secs = secstotimerdown
	Timers:CreateTimer(function()
				if AREENEMIESSHERE1 == true or AREENEMIESSHERE2 == true or AREENEMIESSHERE3 == true or AREENEMIESSHERE4 == true or AREENEMIESSHERE5 == true then
					enemies = true
				else
					enemies = false
				end
				if AREFRIENDSHERE1 == true or AREFRIENDSHERE2 == true or AREFRIENDSHERE3 == true or AREFRIENDSHERE4 == true or AREFRIENDSHERE5 == true then
					friends = true
				else 
					friends = false
				end
				if friends == false then
					secs = secs - 0.1
					if secs <= 0 then
						secs = 0
						aretimerdown = true
					end
				else
					secs = secstotimerdown
					aretimerdown = false
				end

				if friends == false and enemies == true then
					caravanhealth = caravanhealth - damagein100ms
					if caravanhealth <= 0 then
						caravanhealth = 0
					end
					CustomGameEventManager:Send_ServerToAllClients("considerhp", {hp=caravanhealth})
				end
				if caravanhealth < 100 and enemies == false then
					caravanhealth = caravanhealth + healin100ms
					CustomGameEventManager:Send_ServerToAllClients("considerhp", {hp=caravanhealth})
				end

	      	return 0.1
	    end
	)
	--[[Timers:CreateTimer(function()
				print("Health: " .. caravanhealth)
				print("Friends: " .. tostring(friends))
				print("Enemies: " .. tostring(enemies))
	      	return 1.0
	    end
	)]]
end