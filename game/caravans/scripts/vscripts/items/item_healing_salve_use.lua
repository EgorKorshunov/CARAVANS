function item_healing_salve_use(keys)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if keys.ability.spawn then
		keys.ability.spawn.heal = nil
	end
	if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
	else
		keys.ability:SetCurrentCharges(new_charges)
	end
end