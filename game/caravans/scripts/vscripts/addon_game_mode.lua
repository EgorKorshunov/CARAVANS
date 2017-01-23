-- Generated from template

if Caravans == nil then
	Caravans = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
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

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	GameRules:SetPreGameTime(180)
	    GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(0)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	local startwp = Entities:FindByName(nil,"wp2")
    local test = CreateUnitByName("npc_dota_creep_goodguys_melee",startwp:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
    
    test:SetInitialGoalEntity(startwp)

end

-- Evaluate the state of the game
function Caravans:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end