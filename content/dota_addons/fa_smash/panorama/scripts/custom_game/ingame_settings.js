"use strict";

function UpdateKillsToWin()
{
	var victory_condition = CustomNetTables.GetTableValue("game_state", "victory_condition");
	var brawl = CustomNetTables.GetTableValue("game_state", "brawl");
	var multicast = CustomNetTables.GetTableValue("game_state", "multicast");
	var attack_allie = CustomNetTables.GetTableValue("game_state", "attack_allie");
	var aghanim = CustomNetTables.GetTableValue("game_state", "aghanim");
	var mult_gold = CustomNetTables.GetTableValue("game_state", "mult_gold");
	var mult_exp = CustomNetTables.GetTableValue("game_state", "mult_exp");
	if (victory_condition)
	{
		$("#Kills").text = victory_condition.value;
		$("#Brawl").text = brawl.value;
		$("#Multicast").text = multicast.value;
		$("#FriendlyFire").text = attack_allie.value;
		$("#Aghanim").text = aghanim.value;
		$("#GoldMult").text = mult_gold.value;
		$("#XPMult").text = mult_exp.value;
	}
}

function OnGameStateChanged(table, key, data)
{
	$.Msg("Table '", table, "' changed: '", key, "' = ", data);
	UpdateKillsToWin();
}

(function()
{
	UpdateKillsToWin();
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );
})();
