modifier_drop_presents = class({})

--------------------------------------------------------------------------------

function modifier_drop_presents:GetTexture() 
	return "modifier_drop_presents"
end

--------------------------------------------------------------------------------

function modifier_drop_presents:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_drop_presents:OnCreated( kv )
	if IsServer() then
		self.vOldLocation = self:GetParent():GetAbsOrigin()
		self.fLengthCheck = 400
		self:StartIntervalThink( 0.25 )	
	end
end

----------------------------------------------------------------------------

function modifier_drop_presents:OnIntervalThink()
	if IsServer() then
		self.vNewLocation = self:GetParent():GetAbsOrigin()
		self.fDistance = GridNav:FindPathLength(self.vOldLocation, self.vNewLocation)
		if self.fDistance >= self.fLengthCheck then
			local hero = self:GetParent()
			if hero.presents >= 1 then
				for i=1,hero.presents do
					Caravans:DropPresentOnBlink(self.vOldLocation,self.vOldLocation+RandomVector(RandomInt(0,200)),RandomFloat(0.4,0.7))
				end

			    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			    	Caravans:SetDirePresents(self.direPresents + hero.presents)
			    end
			end

		    hero.presents = 0

		    hero:AddNewModifier(hero,nil,"modifier_presents",{duration = -1}):SetStackCount(hero.presents)
		    hero:RemoveModifierByName("modifier_drop_presents")
		end
		self.vOldLocation = self.vNewLocation
	end
end

--------------------------------------------------------------------------------

