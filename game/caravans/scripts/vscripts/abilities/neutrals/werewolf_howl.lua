werewolf_howl = class({})
LinkLuaModifier( "modifier_werewolf_howl", "modifiers/neutrals/modifier_werewolf_howl.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function werewolf_howl:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" ) 
	local duration = self:GetSpecialValueFor(  "duration" )

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:AddNewModifier( self:GetCaster(), self, "modifier_werewolf_howl", { duration = duration } )
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Lycan.Howl", self:GetCaster() )
end

--------------------------------------------------------------------------------
