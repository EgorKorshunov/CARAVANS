Neutrals = Neutrals or {}

spawnersInfo = LoadKeyValues("scripts/kv/spawners.kv")
respawnTime = 60

function Neutrals:Init()
	if not spawnersInfo then
		print('[NEUTRALS] Doesn`t exist or broken file "scripts/kv/spawners.kv"')
	end

	for spawnerName,spawner in pairs(spawnersInfo) do
		local spawnPoint = Entities:FindByName(nil,"spawner_"..spawnerName)

		if spawnPoint then
			spawnPoint = spawnPoint:GetAbsOrigin()

			for unitName,count in pairs(spawner) do
				for i=1,count do
					local unit = CreateUnitByName(unitName,spawnPoint,true,nil,nil,DOTA_TEAM_NEUTRALS)
					unit.spawnPoint = spawnPoint
					unit:SetContextThink("neutralAI",NeutralsAI,0.2)
					unit.timerName = DoUniqueString("Neutrals")
				end
			end
		else
			print("[NEUTRALS] Cant find spawn point for spawn "..spawnerName)
		end

		
	end
end


function Neutrals:OnDeath(killed)
	local unitName = killed:GetUnitName()
	Timers:CreateTimer(respawnTime,
		function()
			local unit = CreateUnitByName(unitName,killed.spawnPoint,true,nil,nil,DOTA_TEAM_NEUTRALS)
			unit.spawnPoint = killed.spawnPoint
			unit:SetContextThink("neutralAI",NeutralsAI,0.2)
			unit.timerName = DoUniqueString("Neutrals")
		end
	)
end

function NeutralsAI(unit)
	if unit:IsPositionInRange(unit.spawnPoint,400) then
		Timers:RemoveTimer(unit.timerName)
		unit.timerStarted = nil
	elseif not unit.timerStarted then
		unit.timerStarted = true
		Timers:CreateTimer(unit.timerName, {
				endTime = 5,
				callback = function() if not unit:IsNull() then unit:MoveToPosition(unit.spawnPoint) unit.timerStarted = nil end end
			}
		)
	end

	return 0.2
end