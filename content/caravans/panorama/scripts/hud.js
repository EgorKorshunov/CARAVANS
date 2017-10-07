var selectedspawnpoint = null;
var hud;
var minimap;
var death = false;
var timergo = false;
function UpdatePresents(table, key, data) {
	if (key == "Presents") {
		$("#RadiantPresents").text = data.presentsInCaravan
		$("#DirePresents").text = data.direPresents
		$("#RadiantPresentsTotal").text = data.radiantPresentsTotal
		$("#DirePresentsTotal").text = data.direPresentsTotal
	}
}
function SetSpawnPoint(number) 
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
		GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : selectedspawnpoint});
	}
	else
	{
		$("#spawnpoint_" + number).style["wash-color"] = 'gray';
		selectedspawnpoint = null;
		GameEvents.SendCustomGameEventToServer("SelectSpawnPoint",{number : 0});
	}
}
function FormatTime(seconds)
{
	var remainder = seconds % 3600;
	var minutes = Math.floor(remainder / 60);
	var seconds = Math.floor(remainder % 60);
	var s = "";
	if (seconds < 10)
		s = "0";
	return minutes + ":" + s + seconds;
}
function StartRespawnTimer()
{
	var time = Players.GetRespawnSeconds(Players.GetLocalPlayer())
	if(time <= 5 && selectedspawnpoint == null)
	{
		$("#UntilTime").style.position = "0% -15% 0%";
		$("#OnRandomlabel").style.visibility = "visible";
		$("#DeathTimer").style.position = "0% 2% 0%";
	}
	else
	{
		$("#OnRandomlabel").style.visibility = "collapse";
		$("#UntilTime").style.position = "0% 0% 0%";
		$("#DeathTimer").style.position = "0% 0% 0%";
	}
	if(time <= 3)
	{
		$("#UntilTime").style.color = "red";
		$("#DeathTimer").style.color = "red";
	}
	if(time > 0)
	{
		$("#DeathTimer").text = FormatTime(time)
		$.Schedule(1, function(){StartRespawnTimer();});
	}
	else
	{
		$("#DeathTimer").text = "0:00"
		timergo = false;
		$("#OnRandomlabel").style.visibility = "collapse";
		$("#UntilTime").style.position = "0% 0% 0%";
		$("#DeathTimer").style.position = "0% 0% 0%";
		$("#UntilTime").style.color = "white";
		$("#DeathTimer").style.color = "white";
	}
}
function CloseButton() 
{
	if(death == false)
	{
		ShowDeathScreen()
	}
	else
	{
		CloseDS()
	}
}
function CloseDeathScreen()
{
	if(Game.IsHUDFlipped())
	{
		$("#DeathPanel").style.position = "100% 0% 0%";
		$("#CloseLabel").style.position = "3% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(90deg)";
	}
	else
	{
		$("#DeathPanel").style.position = "-100% 0% 0%";
		$("#CloseLabel").style.position = "-3% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(-90deg)";
	}
	$("#CloseLabel").text = $.Localize("#Open");
	$("#CloseLabel").style.visibility = "collapse";
	minimap.style.position = "0% 0% 0%";
	for (var i = 1; i <= 4; i++) 
	{
		$("#spawnpoint_" + i).style["wash-color"] = 'gray';
	}
	selectedspawnpoint = null;
	death = false;
}
function CloseDS() 
{
	if(Game.IsHUDFlipped())
	{
		$("#DeathPanel").style.position = "100% 0% 0%";
		$("#CloseLabel").style.position = "3% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(90deg)";
	}
	else
	{
		$("#DeathPanel").style.position = "-100% 0% 0%";
		$("#CloseLabel").style.position = "-3% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(-90deg)";
	}
	$("#CloseLabel").style.visibility = "visible";
	$("#CloseLabel").text = $.Localize("#Open");
	minimap.style.position = "0% 0% 0%";
	death = false;
}
function ShowDeathScreen()
{
	death = true;
	$("#DeathPanel").style.position = "0% 0% 0%";
	$("#CloseLabel").style.visibility = "visible";
	if(Game.IsHUDFlipped())
	{
		$("#CloseLabel").style.position = "-7.8% 24% 0%";
	}
	else
	{
		$("#CloseLabel").style.position = "7.8% 24% 0%";
	}
	$("#CloseLabel").text = $.Localize("#Close");
	$("#CloseLabel").style.transform = "rotateZ(0deg)";
	var pos = -(minimap.FindChildTraverse("minimap").actualuiscale_x * minimap.FindChildTraverse("minimap").desiredlayoutwidth);
	if(Game.IsHUDFlipped())
	{
		pos = -pos
	}
	minimap.style.position = pos + "px 0% 0%";
	if(timergo == false)
	{
		timergo = true
		$.Schedule(0.2, function(){StartRespawnTimer();});
	}
}
(function()
{
	hud = $.GetContextPanel().GetParent().GetParent().GetParent();
	minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	minimap.style["transition-property"] = "position;"
	minimap.style["transition-duration"] = "0.2s;"
	minimap.style["transition-timing-function"] = "ease-in;"
	GameEvents.Subscribe("ShowDeathScreen",ShowDeathScreen);
	GameEvents.Subscribe("HideDeathScreen",CloseDeathScreen);
	CustomNetTables.SubscribeNetTableListener("caravan",UpdatePresents)
})();