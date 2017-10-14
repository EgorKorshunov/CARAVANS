
kobold_piercing_strike = class({})
LinkLuaModifier( "modifier_kobold_piercing_strike", "abilities/neutrals/kobold_piercing_strike.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kobold_piercing_strike:GetIntrinsicModifierName()
	return "modifier_kobold_piercing_strike"
end

--------------------------------------------------------------------------------


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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
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

function modifier_kobold_piercing_strike:OnAttackLanded(params) 
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return 
		end

		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.pseudo:Trigger() then
				local damageTable = {
						 	victim = params.target, 
						 	attacker = params.attacker, 
						 	damage = self.damage, 
						 	damage_type = DAMAGE_TYPE_PHYSICAL,
						 	ability = self:GetAbility()
						}

				ApplyDamage(damageTable)
				EmitSoundOn( "DOTA_Item.MKB.Minibash", params.attacker )
			end
		end
	end
end

--------------------------------------------------------------------------------
