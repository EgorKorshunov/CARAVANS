modifier_kobold_piercing_strike = class({})

--------------------------------------------------------------------------------

function modifier_kobold_piercing_strike:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_piercing_strike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_piercing_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_kobold_piercing_strike:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_piercing_strike:GetModifierProcAttack_BonusDamage_Pure( params )
	if IsServer() then
		if self.pseudo:Trigger() then
			return self.damage 
		end
	end
end

--------------------------------------------------------------------------------
