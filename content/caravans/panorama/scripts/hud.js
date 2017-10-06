var selectedspawnpoint = null;
var hud;
var spawnpointsstyle = {"1" : "1% -41% 0px;","2" : "19.5% 1.4% 0px;","3" : "-6% 42% 0px;","4" : "-19.5% 6% 0px;"}
function UpdatePresents(table, key, data) {
	if (key == "Presents") {
		$("#RadiantPresents").text = data.presentsInCaravan
		$("#DirePresents").text = data.direPresents
		$("#RadiantPresentsTotal").text = data.radiantPresentsTotal
		$("#DirePresentsTotal").text = data.direPresentsTotal
	}
}
var SetSpawnPoint = (function(number)
{
	return function()
	{
		if(selectedspawnpoint != number)
		{
			var minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
			minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + number).style["wash-color"] = 'white';
			for (var i = 1; i <= 4; i++) 
			{
				if(i != number)
				{
					if(minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + i) != null)
					{
						minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + i).style["wash-color"] = 'gray';
					}
				}
			}
			selectedspawnpoint = number;
			GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : selectedspawnpoint});
		}
		else
		{
			minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + number).style["wash-color"] = 'gray';
			selectedspawnpoint = null;
			GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : 0});
		}
	}
});
function CloseDeathScreen()
{
	var minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	minimap.style['position'] = "0% 0% 0%";
	for (var i = 1; i <= 4; i++) 
	{
		var panel = minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + i);
		panel.style.visibility = "collapse";
	}
	$("#choisespawnpoint").style.visibility = "collapse;";
	$("#closedeathscreen").style.visibility = "collapse;";
	$("#opendeathscreen").style.visibility = "collapse;";
}
var SpawnPointOver = (function(panel)
{
	return function()
	{
		panel.style["background-size"] = "25px 25px;";
	}
});
var SpawnPointOut = (function(panel)
{
	return function()
	{
		panel.style["background-size"] = "20px 20px;";
	}
});
function CloseDS() 
{
	var minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	minimap.style['position'] = "0% 0% 0%";
	for (var i = 1; i <= 4; i++) 
	{
		var panel = minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + i);
		panel.style.visibility = "collapse";
	}
	$("#choisespawnpoint").style.visibility = "collapse;";
	$("#closedeathscreen").style.visibility = "collapse;";
	$("#opendeathscreen").style.visibility = "visible;";
}
function ShowDeathScreen()
{
	var minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	minimap.style['position'] = "0% -30% 0%";
	for (var i = 1; i <= 4; i++) 
	{
		var panel = minimap.FindChildTraverse("minimap_block").FindChildTraverse("spawnpoint_" + i);
		if(panel == null)
		{
			panel = $.CreatePanel("Panel",minimap.FindChildTraverse("minimap_block"),"spawnpoint_" + i);
			panel.style.align = "center center;";
			panel.style.height = "25px;";
			panel.style.width = "25px;";
			panel.style["background-size"] = "20px 20px;";
			panel.style["background-repeat"] = "no-repeat;"
			panel.style["background-position"] = "center;"
			panel.style["background-image"] = 'url("file://{images}/custom_game/spawnpoint.png");'
			panel.style.position = spawnpointsstyle[i]
			panel.SetPanelEvent("onmouseover",SpawnPointOver(panel));
			panel.SetPanelEvent("onmouseout",SpawnPointOut(panel));
			panel.SetPanelEvent("onmouseactivate",SetSpawnPoint(i));
		}
		panel.style["wash-color"] = "gray";
		panel.style.visibility = "visible";
	}
	$("#choisespawnpoint").style.visibility = "visible;";
	$("#closedeathscreen").style.visibility = "visible;";
	$("#opendeathscreen").style.visibility = "collapse;";
}
(function()
{
	hud = $.GetContextPanel().GetParent().GetParent().GetParent();
	var minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	minimap.style["transition-property"] = "position;"
	minimap.style["transition-duration"] = "0.2s;"
	minimap.style["transition-timing-function"] = "ease-in;"
	GameEvents.Subscribe("ShowDeathScreen",ShowDeathScreen);
	GameEvents.Subscribe("HideDeathScreen",CloseDeathScreen);
	CustomNetTables.SubscribeNetTableListener("caravan",UpdatePresents)
})();