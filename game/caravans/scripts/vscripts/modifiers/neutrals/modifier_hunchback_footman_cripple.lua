
modifier_hunchback_footman_cripple = class({})

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_hunchback_footman_cripple:OnAttackLanded(params) 
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return 
		end

		if self:GetParent() == params.attacker then
			if params.target ~= nil then
				params.target:AddNewModifier(params.attacker,self:GetAbility(),"modifier_hunchback_footman_cripple_debuff", {duration = self.duration})
			end
		end
	end
end

--------------------------------------------------------------------------------
