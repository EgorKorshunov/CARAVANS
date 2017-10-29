modifier_centaur_joe_axe_power = class({})

--------------------------------------------------------------------------------

function modifier_centaur_joe_axe_power:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_centaur_joe_axe_power:OnCreated( kv )
	self.cleave_percent = self:GetAbility():GetSpecialValueFor( "cleave_percent" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

--------------------------------------------------------------------------------

function modifier_centaur_joe_axe_power:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_centaur_joe_axe_power:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.cleave_percent * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.cleave_radius, self.cleave_radius, self.cleave_radius, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )
			end
		end
	end
	
	return 0
end
