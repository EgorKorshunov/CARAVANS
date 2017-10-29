frostbitten_warlock_frozen_statue = class({})
LinkLuaModifier( "modifier_frostbitten_warlock_frozen_statue", "modifiers/neutrals/modifier_frostbitten_warlock_frozen_statue.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function frostbitten_warlock_frozen_statue:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	
	if hTarget:TriggerSpellAbsorb(self) then
		return 
	end

	local duration
	local duration_hero = self:GetSpecialValueFor( "duration_hero" ) 
	local duration_creep = self:GetSpecialValueFor( "duration_creep" ) 

	if hTarget:IsHero() then
		duration = duration_hero
	else
		duration = duration_creep
	end


	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_frostbitten_warlock_frozen_statue", { duration = duration } )
	EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", hTarget ) 
end

--------------------------------------------------------------------------------
