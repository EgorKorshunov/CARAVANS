require('timers')

if Caravans == nil then
	Caravans = class({})
end

_G.CaravanUnitTable = {}



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
	Caravans = Caravans()
	Caravans:InitGameMode()
	GameRules.Caravans = Caravans
end

function Caravans:InitGameMode()
    ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(Caravans, "OnStateChange"),self)

	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	--GameRules:SetPreGameTime(180)
	GameRules:SetPreGameTime(10)
	GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)


	curwp = 2
	wp1 = Entities:FindByName(nil,"wp1"):GetOrigin()
	wp2 = Entities:FindByName(nil,"wp2"):GetOrigin()
	wp3 = Entities:FindByName(nil,"wp3"):GetOrigin()
	wp4 = Entities:FindByName(nil,"wp4"):GetOrigin()
	wp5 = Entities:FindByName(nil,"wp5"):GetOrigin()
	wp6 = Entities:FindByName(nil,"wp6"):GetOrigin()
	wp7 = Entities:FindByName(nil,"wp7"):GetOrigin()
	wp8 = Entities:FindByName(nil,"wp8"):GetOrigin()
	wp9 = Entities:FindByName(nil,"wp9"):GetOrigin()
	wp10 = Entities:FindByName(nil,"wp10"):GetOrigin()
	wp11 = Entities:FindByName(nil,"wp11"):GetOrigin()
	wp12 = Entities:FindByName(nil,"wp12"):GetOrigin()
	wp13 = Entities:FindByName(nil,"wp13"):GetOrigin()
	wp14 = Entities:FindByName(nil,"wp14"):GetOrigin()
	wp15 = Entities:FindByName(nil,"wp15"):GetOrigin()
	wp16 = Entities:FindByName(nil,"wp16"):GetOrigin()
	wp17 = Entities:FindByName(nil,"wp17"):GetOrigin()
	wp18 = Entities:FindByName(nil,"wp18"):GetOrigin()
	wp19 = Entities:FindByName(nil,"wp19"):GetOrigin()
	wp20 = Entities:FindByName(nil,"wp20"):GetOrigin()
	wp21 = Entities:FindByName(nil,"wp21"):GetOrigin()
	wp22 = Entities:FindByName(nil,"wp22"):GetOrigin()
	wp23 = Entities:FindByName(nil,"wp23"):GetOrigin()
	wp24 = Entities:FindByName(nil,"wp24"):GetOrigin()
	wp25 = Entities:FindByName(nil,"wp25"):GetOrigin()
	waypoints = {wp1,wp2,wp3,wp3,wp4,wp5,wp6,wp7,wp8,wp9,wp10,wp11,wp12,wp13,wp13,wp14,wp15,wp16,wp17,wp18,wp19,wp20,wp21,wp22,wp23,wp24,wp25}


	--local startwp = Entities:FindByName(nil,"wp2")
    --local test = CreateUnitByName("npc_dota_creep_goodguys_melee",startwp:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
    
    --test:SetInitialGoalEntity(startwp)

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

LinkLuaModifier("modifier_caravan","modifiers",LUA_MODIFIER_MOTION_NONE)

function Caravans:OnStateChange(keys)
	if GameRules:State_Get() == 8 then
		runmapai()
		local caravanunits = 1
		local firstcreep = CreateUnitByName("npc_dota_caravan_unit",waypoints[1],true,nil,nil,DOTA_TEAM_GOODGUYS)
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