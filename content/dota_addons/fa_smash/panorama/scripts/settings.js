//--------------------------------------------------------------------------------------------------
// CUSTOM HOST PANEL
//--------------------------------------------------------------------------------------------------
var IsHost = false;

function ValueChange(name)
{
	if (!IsHost) return

	var panel = $("#"+name);
	if (panel !== null){
		var new_value = parseInt(panel.text)
		var max_value = 0
		var min_value = 0

		if (new_value <= max_value && new_value >= min_value)
			panel.text = new_value
		else
			if (new_value < min_value)
				panel.text = min_value
			else
				panel.text = max_value
	}
	GameEvents.SendCustomGameEventToServer("setting_change", {setting: name, value: panel.text});
}

function Toggle(setting) {
	if (!IsHost)
		$("#"+setting).checked = !$("#"+setting).checked;
	else
		GameEvents.SendCustomGameEventToServer("setting_change", {setting: setting, value: $("#"+setting).checked}); 
}

function OnRadioPressed(setting, value) {
	GameEvents.SendCustomGameEventToServer("setting_change", {setting: setting, value: value});
}

var number_settings = [
	"mult_gold", "mult_exp", "mult_respawn"
]
var bool_settings = [
	"aghanim",
	"smash_bros",
	"cast_instantly","cast_is_touch","reduce_cd",
	"kill_soul","kill_soul_agility","kill_soul_strength","kill_soul_int","kill_explosion",
	"all_random",
	"river_heal","river_irradiated","river_slippery","river_ice","mlg_sound","brawl",
	"hero_branches", "all_random",
	//"misc_randproj",
]
function UpdateSettings() {
	if (!IsHost)
	{
//		$.Msg("Host Changed Settings: ", CustomNetTables.GetAllTableValues("settings"))

//		for (var k of number_settings)
//		{
//			$("#"+k).text = CustomNetTables.GetTableValue("settings", k).value
//		}

		//bools
//		for (var k of bool_settings)
//		{
//			$("#"+k).checked = CustomNetTables.GetTableValue("settings", k).value == 1;
//		}

		/*//radio
		currentRadioOption = CustomNetTables.GetTableValue("settings", "win_at_tier").value
		for (var i in radios)
		{
			var panel = radios[i]
			panel.checked = i == currentRadioOption
		}*/
	}
}

//--------------------------------------------------------------------------------------------------
// Check to see if the local player has host privileges and set the 'player_has_host_privileges' on
// the root panel if so, this allows buttons to only be displayed for the host.
//--------------------------------------------------------------------------------------------------
function CheckForHostPrivileges()
{
	// SetStartingGold()
	var playerInfo = Game.GetLocalPlayerInfo();
	if ( !playerInfo )
		return;

	// Set the "player_has_host_privileges" class on the panel, this can be used 
	// to have some sub-panels on display or be enabled for the host player.
	IsHost = playerInfo.player_has_host_privileges;
	$.GetContextPanel().SetHasClass( "player_has_host_privileges", IsHost );

	// Update the Host name
	var playerIDs = Game.GetAllPlayerIDs()
	for (var i = 0; i < playerIDs.length; i++) {
		var pInfo = Game.GetPlayerInfo( i );
		if ( pInfo && pInfo.player_has_host_privileges){
			var HostName = Players.GetPlayerName( i )
			$('#Host').text = "HOST: "+HostName
		}
	}
	$.Schedule(50.5, CheckForHostPrivileges)
}

//--------------------------------------------------------------------------------------------------
// Entry point called when the team select panel is created
//--------------------------------------------------------------------------------------------------
(function()
{
	CheckForHostPrivileges();
	CustomNetTables.SubscribeNetTableListener("settings", UpdateSettings)
})();
