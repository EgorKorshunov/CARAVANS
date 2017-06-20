var currhp = 100
function hpbarchange() 
{
	var panel = $("#HP")
	panel.style.width = 1*currhp + "%"
}
function considerhp(table) 
{
	currhp = table.hp;
	hpbarchange()
}
(function()
{
	GameEvents.Subscribe("considerhp",considerhp);
})();