frostbitten_giant_ice_spikes = class({})
LinkLuaModifier( "modifier_frostbitten_giant_ice_spikes_motion", "modifiers/neutrals/modifier_frostbitten_giant_ice_spikes_motion", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

function frostbitten_giant_ice_spikes:OnSpellStart()
	if IsServer() then
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.length = self:GetSpecialValueFor( "length" )
		self.speed = self:GetSpecialValueFor( "speed" )
		self.width = self:GetSpecialValueFor( "width" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )

		self.speed = self.speed * ( self.length / ( self.length - self.width ) )

		local info = {
			EffectName = "particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.width,
			fEndRadius = self.width,
			vVelocity = vDirection * self.speed,
			fDistance = self.length,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_NyxAssassin.Impale" , self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function frostbitten_giant_ice_spikes:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			local kv =
			{
				vLocX = hTarget:GetOrigin().x,
				vLocY = hTarget:GetOrigin().y,
				vLocZ = hTarget:GetOrigin().z
			}

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_frostbitten_giant_ice_spikes_motion", kv )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
			EmitSoundOn( "Hero_NyxAssassin.Impale.Target" , hTarget )
		end

		return false
	end
end