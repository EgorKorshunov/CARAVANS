function UpdatePresents(table, key, data) {
	if (key == "Presents") {
		$("#RadiantPresents").text = data.presentsInCaravan
		$("#DirePresents").text = data.direPresents
		$("#RadiantPresentsTotal").text = data.radiantPresentsTotal
		$("#DirePresentsTotal").text = data.direPresentsTotal
	}
}


(function()
{
	CustomNetTables.SubscribeNetTableListener("caravan",UpdatePresents)
})();