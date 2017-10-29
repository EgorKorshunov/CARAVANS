spider_paralyzer = class({})
LinkLuaModifier( "modifier_spider_paralyzer_damage", "modifiers/neutrals/modifier_spider_paralyzer_damage", LUA_MODIFIER_MOTION_VERTICAL )
LinkLuaModifier( "modifier_spider_paralyzer_root", "modifiers/neutrals/modifier_spider_paralyzer_root", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

function spider_paralyzer:OnSpellStart()
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
		self.delay = self:GetSpecialValueFor( "delay" )

		self.speed = self.speed * ( self.length / ( self.length - self.width ) )

		local info = {
			EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
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
		EmitSoundOn( "Hero_Venomancer.VenomousGale" , self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function spider_paralyzer:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spider_paralyzer_damage", { duration = self.delay } )
			
			EmitSoundOn( "Hero_Venomancer.VenomousGaleImpact" , hTarget )
		end

		return false
	end
end