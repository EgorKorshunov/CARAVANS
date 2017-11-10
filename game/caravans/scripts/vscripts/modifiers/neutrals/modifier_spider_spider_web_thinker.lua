modifier_spider_spider_web_thinker = class({})

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:GetModifierAura()
	return "modifier_spider_spider_web_effect"
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		self.webParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_web.vpcf",PATTACH_ABSORIGIN,self:GetParent())
		ParticleManager:SetParticleControl(self.webParticle,1,Vector(self.radius,0,self.radius))
		--EmitSoundOn("Hero_Broodmother.SpinWebCast",self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spider_web_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.webParticle,true)
	end
end

--------------------------------------------------------------------------------
