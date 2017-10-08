var selectedspawnpoint = null;
var hud;
var minimap;
var killcam;
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
	var time = Players.GetRespawnSeconds(Players.GetLocalPlayer()) + 1
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
	$.Msg(death)
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
	death = false;
	if(Game.IsHUDFlipped())
	{
		$("#DeathPanel").style.position = "100% 0% 0%";
		$("#CloseLabel").style.position = "2.5% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(90deg)";
	}
	else
	{
		$("#DeathPanel").style.position = "-100% 0% 0%";
		$("#CloseLabel").style.position = "-2.5% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(-90deg)";
	}
	$("#CloseLabel").text = $.Localize("#Open");
	$("#CloseLabel").style.visibility = "collapse";
	for (var i = 1; i <= 4; i++) 
	{
		$("#spawnpoint_" + i).style["wash-color"] = 'gray';
	}
	selectedspawnpoint = null;
}
function CloseDS() 
{
	death = false;
	if(Game.IsHUDFlipped())
	{
		$("#DeathPanel").style.position = "100% 0% 0%";
		$("#CloseLabel").style.position = "2.5% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(90deg)";
	}
	else
	{
		$("#DeathPanel").style.position = "-100% 0% 0%";
		$("#CloseLabel").style.position = "-2.5% 0% 0%";
		$("#CloseLabel").style.transform = "rotateZ(-90deg)";
	}
	$("#CloseLabel").style.visibility = "visible";
	$("#CloseLabel").text = $.Localize("#Open");
}
function ShowDeathScreen()
{
	death = true;
	$("#DeathPanel").style.position = "0% 0% 0%";
	$("#CloseLabel").style.visibility = "visible";
	$("#CloseLabel").text = $.Localize("#Close");
	$("#CloseLabel").style.transform = "rotateZ(0deg)";
	if(timergo == false)
	{
		timergo = true
		$.Schedule(0.2, function(){StartRespawnTimer();});
	}
	HideMiniMapAndKillCam();
}
function HideMiniMapAndKillCam()
{
	var pos = -250;
	if(Game.IsHUDFlipped())
	{
		pos = -pos
	}
	minimap.style.position = pos + "px 0% 0%";
	killcam.style.transform = "translateX("+ pos * 2 +"px)";
	if(Game.IsHUDFlipped())
	{
		$("#CloseLabel").style.position = "-7.2% 24% 0%";
	}
	else
	{
		$("#CloseLabel").style.position = "7.2% 24% 0%";
	}
	if(death == true)
	{
		$.Schedule(0.01, function(){HideMiniMapAndKillCam();});
	}
	else
	{
		minimap.style.position = "0% 0% 0%";
		killcam.style.transform = "translateX(0px)";
		if(Game.IsHUDFlipped())
		{
			$("#CloseLabel").style.position = "2.5% 0% 0%";
			$("#CloseLabel").style.transform = "rotateZ(90deg)";
		}
		else
		{
			$("#CloseLabel").style.position = "-2.5% 0% 0%";
			$("#CloseLabel").style.transform = "rotateZ(-90deg)";
		}
	}
}
(function()
{
	hud = $.GetContextPanel().GetParent().GetParent().GetParent();
	minimap = hud.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
	killcam = hud.FindChildTraverse("HUDElements").FindChildTraverse("KillCam");
	minimap.style["transition-property"] = "position;"
	minimap.style["transition-duration"] = "0.2s;"
	minimap.style["transition-timing-function"] = "ease-in;"
	GameEvents.Subscribe("ShowDeathScreen",ShowDeathScreen);
	GameEvents.Subscribe("HideDeathScreen",CloseDeathScreen);
	CustomNetTables.SubscribeNetTableListener("caravan",UpdatePresents)
})();