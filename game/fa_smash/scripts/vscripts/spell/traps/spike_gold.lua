spike_gold = class({})

--------------------------------------------------------------------------------

function spike_gold:OnSpellStart()
	self.gold_give = self:GetSpecialValueFor( "gold_give" )
	print("gold")
	local target = self:GetCursorTarget()
	target:ModifyGold(500, true, 0)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



