hunchback_mage_fire_wave = class({})
LinkLuaModifier( "modifier_hunchback_mage_fire_wave_debuff", "modifiers/neutrals/modifier_hunchback_mage_fire_wave_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hunchback_mage_fire_wave:OnSpellStart()
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
		self.start_width = self:GetSpecialValueFor( "start_width" )
		self.end_width = self:GetSpecialValueFor( "end_width" )
		self.duration = self:GetSpecialValueFor( "duration" )

		self.speed = self.speed * ( self.length / ( self.length - self.start_width ) )

		local info = {
			EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.start_width,
			fEndRadius = self.end_width,
			vVelocity = vDirection * self.speed,
			fDistance = self.length,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_DragonKnight.BreathFire" , self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function hunchback_mage_fire_wave:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_hunchback_mage_fire_wave_debuff", { duration = self.duration } )
		end

		return false
	end
end