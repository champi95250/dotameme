"use strict";


(function()
{

	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()

	/*var func  = function() {
		$.Schedule(0.03,func)
		var scoreboard = dotaHud.FindChildTraverse("scoreboard")
		$.DispatchEvent("DOTACustomUI_SetFlyoutScoreboardVisible", !scoreboard.BHasClass("ScoreboardClosed"))
	}
	func()*/

	dotaHud.FindChildTraverse("GameInfoButton").style.visibility = "collapse";


	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeaderCenter").style.marginLeft = "1750px"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("RadiantTeamPlayers").style.marginLeft = "-750px"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("TeamPurchasesStrategyControl").style.visibility = "collapse";

	




	//Valve can`t fix, but I can)


})();

