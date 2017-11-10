
modifier_hunchback_golem_fire_protection = class({})

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_hunchback_golem_fire_protection:OnAttackLanded(params) 
	if IsServer() then
		if params.target == self:GetParent() then
			if self:GetParent():PassivesDisabled() then
				return 
			end

			params.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_hunchback_golem_fire_protection_debuff", {duration = self.duration})
			
		end
	end
end

--------------------------------------------------------------------------------
