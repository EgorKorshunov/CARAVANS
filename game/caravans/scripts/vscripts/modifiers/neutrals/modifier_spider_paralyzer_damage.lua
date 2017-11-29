
modifier_spider_paralyzer_damage = class({})

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:OnCreated( kv )
	if IsServer() then
		self.root_duration = self:GetAbility():GetSpecialValueFor( "root_duration" )
	end
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spider_paralyzer_damage:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_spider_paralyzer_root", { duration = self.root_duration} )
	end
end

--------------------------------------------------------------------------------
