"use strict";


(function() {
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()
	dotaHud.FindChildTraverse("GameInfoButton").style.visibility = "collapse";
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("RadiantTeamPlayers").style.visibility = "collapse";
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("TeamPurchasesStrategyControl").style.visibility = "collapse";
})();

