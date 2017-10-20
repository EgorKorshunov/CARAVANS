furbolg_disruptor_bloodlust = class({})
LinkLuaModifier( "modifier_furbolg_disruptor_bloodlust", "modifiers/neutrals/modifier_furbolg_disruptor_bloodlust.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function furbolg_disruptor_bloodlust:OnAbilityPhaseStart()
	EmitSoundOn( "Hero_OgreMagi.Fireblast.Cast", self:GetCursorTarget() )
end

--------------------------------------------------------------------------------

function furbolg_disruptor_bloodlust:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local hTarget = self:GetCursorTarget()

	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_furbolg_disruptor_bloodlust", { duration = duration } )
	EmitSoundOn( "Hero_OgreMagi.Fireblast.Target", hTarget )
end

--------------------------------------------------------------------------------
