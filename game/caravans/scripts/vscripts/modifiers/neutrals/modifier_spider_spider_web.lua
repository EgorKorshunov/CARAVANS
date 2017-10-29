
modifier_spider_spider_web = class({})

--------------------------------------------------------------------------------

function modifier_spider_spider_web:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		self:StartIntervalThink( self.duration )
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web:OnIntervalThink()
	if IsServer() then
		CreateModifierThinker(
			self:GetParent(),
			self:GetAbility(),
			"modifier_spider_spider_web_thinker",
			{ duration = self.duration },
			self:GetParent():GetOrigin(),
			self:GetParent():GetTeamNumber(),
			false
		)	
	end
end

--------------------------------------------------------------------------------
