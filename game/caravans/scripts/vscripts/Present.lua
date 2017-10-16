function PickupPresent(event)
	--print(event.ability:GetClassname())
	event.caster:RemoveItem(event.ability)
	Caravans:PickupPresent(event.caster)
end