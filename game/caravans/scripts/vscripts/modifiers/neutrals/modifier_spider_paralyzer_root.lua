modifier_spider_paralyzer_root = class({})

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:OnCreated( kv )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	if IsServer() then
		local damage = {
					victim = self:GetParent(),
					attacker = self:GetCaster(),
					damage = self.damage_per_second,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility()
				}

		ApplyDamage( damage )
		self:StartIntervalThink( 1 )	
	end
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:GetEffectName()
	return "particles/units/heroes/hero_broodmother/broodmother_incapacitatingbite_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_root:OnIntervalThink()
	if IsServer() then
		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_per_second,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
