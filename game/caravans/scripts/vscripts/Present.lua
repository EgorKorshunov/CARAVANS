function PickupPresent(event)
	--print(event.ability:GetClassname())
	event.caster:RemoveItem(event.ability)
	Caravans:PickupPresent(event.caster)
	event.caster:AddNewModifier(event.caster, nil, "modifier_drop_presents", {duration = 5})
end