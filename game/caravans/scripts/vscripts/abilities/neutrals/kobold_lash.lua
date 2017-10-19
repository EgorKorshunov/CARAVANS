kobold_lash = class({})
LinkLuaModifier( "modifier_kobold_lash", "modifiers/neutrals/modifier_kobold_lash.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kobold_lash:OnSpellStart()
	local health_reduction = self:GetSpecialValueFor( "health_reduction" ) 
	local duration = self:GetSpecialValueFor("duration")
	local hTarget = self:GetCursorTarget()

	local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = health_reduction,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

	ApplyDamage( damage )
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_kobold_lash", { duration = duration } )
	EmitSoundOn( "Hero_Dazzle.Poison_Tick", hTarget )
end

--------------------------------------------------------------------------------
