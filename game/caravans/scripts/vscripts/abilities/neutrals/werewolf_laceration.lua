
werewolf_laceration = class({})
LinkLuaModifier( "modifier_werewolf_laceration", "abilities/neutrals/werewolf_laceration.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_werewolf_laceration_debuff", "abilities/neutrals/werewolf_laceration.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function werewolf_laceration:GetIntrinsicModifierName()
	return "modifier_werewolf_laceration"
end

--------------------------------------------------------------------------------


modifier_werewolf_laceration = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.laceration = false

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("chance")*0.01)
	end
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:OnAttackLanded(params) 
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return 
		end

		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.laceration == true then
				params.target:AddNewModifier(params.attacker,self:GetAbility(),"modifier_werewolf_laceration_debuff", {duration = self.duration})
				EmitSoundOn( "hero_bloodseeker.rupture.cast", params.attacker )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		self.laceration = false
		if self.pseudo:Trigger() then
			self.laceration = true
			return self.damage 
		end
	end
end

--------------------------------------------------------------------------------

modifier_werewolf_laceration_debuff = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:OnCreated( kv )
	self.extra_damage_income_percentage = self:GetAbility():GetSpecialValueFor( "extra_damage_income_percentage" )
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetEffectName()
	return "particles/items2_fx/sange_maim_d.vpcf"
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:OnAttackLanded(params) 
	if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end

--------------------------------------------------------------------------------

function modifier_werewolf_laceration_debuff:GetModifierIncomingPhysicalDamage_Percentage(params) 
	if IsServer() then
		if not self:GetParent():IsIllusion() and self.attack_record == params.record then 
			return self.extra_damage_income_percentage
		end 
	end
end

--------------------------------------------------------------------------------
