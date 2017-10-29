
modifier_centaur_doc_life_transfer_heal = class({})

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_heal:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_heal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_heal:OnCreated( kv )
	if IsServer() then
		self.health_percent_interrupt = self:GetAbility():GetSpecialValueFor( "health_percent_interrupt" ) 
		self.health_transfer = self:GetAbility():GetSpecialValueFor( "health_transfer" )
		self.break_radius = self:GetAbility():GetSpecialValueFor( "break_radius" )
		self.health_transfer_per_tick = self.health_transfer / 5
		self:StartIntervalThink( 0.2 )

		self.lifeTransferParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_give.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.lifeTransferParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_heal:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetRangeToUnit(self:GetCaster()) > self.break_radius then
			self:Destroy()
			return
		end 

		local target_health = self:GetParent():GetHealth()
		local missing_health = self:GetParent():GetMaxHealth() - target_health
		if missing_health < self.health_transfer_per_tick then
			self.health_to_transfer = missing_health
		else
			self.health_to_transfer = self.health_transfer_per_tick
		end


		if self:GetParent():GetHealth()  then
			local health_reduce = {
					victim = self:GetCaster(),
					attacker = self:GetCaster(),
					damage = self.health_to_transfer,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}

			ApplyDamage( health_reduce )
			self:GetParent():Heal(self.health_to_transfer,self:GetCaster())
		end
	end
end

--------------------------------------------------------------------------------

function modifier_centaur_doc_life_transfer_heal:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.lifeTransferParticle,true)
	end
end

--------------------------------------------------------------------------------
