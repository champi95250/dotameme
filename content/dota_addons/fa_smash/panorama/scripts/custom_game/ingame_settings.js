"use strict";

//function ShowTimer( data )
//{
//	$( "#Timer" ).AddClass( "timer_visible" );
//}

function UpdateKillsToWin()
{
	var victory_condition = CustomNetTables.GetTableValue( "game_state", "victory_condition" );
	if ( victory_condition )
	{
		$("#Kills").text = victory_condition.kills_to_win;
	}
}

function OnGameStateChanged( table, key, data )
{
	$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	UpdateKillsToWin();
}

(function()
{
	UpdateKillsToWin();
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );
})();
