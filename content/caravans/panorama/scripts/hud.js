var runes = 0;
var selectedspawnpoint = null;
var buybackcost = 10;
var runeslabel = null;
function UpdatePresents(table, key, data) {
	if (key == "Presents") {
		$("#RadiantPresents").text = data.presentsInCaravan
		$("#DirePresents").text = data.direPresents
		$("#RadiantPresentsTotal").text = data.radiantPresentsTotal
		$("#DirePresentsTotal").text = data.direPresentsTotal
	}
}
function SelectSpawnPoint(number)
{
	if(runes >= buybackcost)
	{
		if(selectedspawnpoint != number)
		{
			$("#spawnpoint_" + number).style["wash-color"] = 'white';
			for (var i = 1; i <= 4; i++) 
			{
				if(i != number)
				{
					$("#spawnpoint_" + i).style["wash-color"] = 'gray';
				}
			}
			selectedspawnpoint = number;
			$("#BuyBack").style.opacity = "1.0";
			$("#byubackcost").text = buybackcost;
			GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : selectedspawnpoint});
		}
		else
		{
			$("#spawnpoint_" + number).style["wash-color"] = 'gray';
			selectedspawnpoint = null;
			$("#BuyBack").style.opacity = "0.0";
			GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : 0});
		}
	}
	else
	{
		selectedspawnpoint = null;
		GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : 0});
	}
}
function runesupdate(t) 
{
	runes = t.runes
	runeslabel.text = runes;
}
function BuyBack() 
{
	GameEvents.SendCustomGameEventToServer("BuyBack",{});
}
function CloseDeathScreen()
{
	$("#deathscreen").style.opacity = "0.0";
}
function ShowDeathScreen()
{
	$("#deathscreen").style.opacity = "1.0";
	for (var i = 1; i <= 4; i++) 
	{
		$("#spawnpoint_" + i).style["wash-color"] = 'gray';
	}
	$("#BuyBack").style.opacity = "0.0";
}
function SetRunesPanelStyle(runespanel)
{
	runespanel.style["height"] = "40%;"
	runespanel.style["margin-bottom"] = "9%;"
	runespanel.style["width"] = "45%;"
	runespanel.style["align"] = "right bottom;"
	runeslabel = $.CreatePanel( "Label", runespanel, "runeslabel" );
	runeslabel.text = runes;
	runeslabel.style["align"] = "right center;"
	runeslabel.style["color"] = "#8554ad;"
	runeslabel.style["font-size"] = "22px;"
	runeslabel.style["margin-right"] = "35%;"
	runeslabel.style["text-shadow"] = "0px 1px 0px 3.0 #00000077;"
	runeslabel.style["font-weight"] = "bold;"
	runeslabel.style["text-align"] = "right;"
	var panel = $.CreatePanel( "Panel", runespanel, "runesicon" );
	panel.style["align"] = "right center;"
	panel.style["background-image"] = 'url("file://{images}/custom_game/spawnpoint.png");'
	panel.style["height"] = "25px;"
	panel.style["width"] = "25px;"
	panel.style["background-size"] = "100% 100%;"
	panel.style["background-repeat"] = "no-repeat;"
	panel.style["background-position"] = "center;"
	panel.style["margin-right"] = "15%;"
}
(function()
{
	var hud = $.GetContextPanel().GetParent().GetParent().GetParent();
	var quickbuy = hud.FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("shop_launcher_block").FindChildTraverse("quickbuy");
	var runespanel = quickbuy.FindChildTraverse("runespanel")
	GameEvents.Subscribe("RunesUpdate",runesupdate);
	GameEvents.Subscribe("ShowDeathScreen",ShowDeathScreen);
	GameEvents.Subscribe("HideDeathScreen",CloseDeathScreen);
	CustomNetTables.SubscribeNetTableListener("caravan",UpdatePresents)
	if(runespanel == null)
	{
		runespanel = $.CreatePanel( "Panel", quickbuy, "runespanel" );
		SetRunesPanelStyle(runespanel);
	}
})();