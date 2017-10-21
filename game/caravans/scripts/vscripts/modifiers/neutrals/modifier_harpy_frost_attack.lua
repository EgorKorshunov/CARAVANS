
modifier_harpy_frost_attack = class({})

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:OnCreated( kv )
	self.initial_damage = self:GetAbility():GetSpecialValueFor( "initial_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:OnAttackLanded(params) 
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return 
		end

		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil then
				hTarget:AddNewModifier(params.attacker,self:GetAbility(),"modifier_harpy_frost_attack_debuff", {duration = self.duration})
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_harpy_frost_attack:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() then
		return self.initial_damage 
	end
end

--------------------------------------------------------------------------------
