modifier_ryze = class({})

--------------------------------------------------------------------------------

function modifier_ryze:IsHidden()
	return true
end

function modifier_ryze:IsDebuff()
	return false
end

function modifier_ryze:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
if IsServer() then

	function modifier_ryze:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		}
	 
		return funcs
	end

--------------------------------------------------------------------------------

	function modifier_ryze:OnAbilityExecuted( event )
		local parent = self:GetParent()
		
		if event.unit == parent then
			local spell = event.ability
			
			if spell:IsItem() then
				if spell:GetManaCost( -1 ) <= 0 then
					return
				end
			elseif not spell:ProcsMagicStick() then
				return
			end
			
			for i = 0, 15 do
				local spell2 = parent:GetAbilityByIndex( i )
				
				if spell2 then
					local cd = spell2:GetCooldownTimeRemaining()
					
					if spell ~= spell2 and cd > 0 then
						spell2:EndCooldown()
						spell2:StartCooldown( cd * 0.5 )
					end
				end
			end
			
			for i = 0, 5 do
				local spell2 = parent:GetItemInSlot( i )
				
				if spell2 then
					local cd = spell2:GetCooldownTimeRemaining()
					
					if spell ~= spell2 and cd > 0 then
						spell2:EndCooldown()
						spell2:StartCooldown( cd * 0.5 )
					end
				end
			end
		end
	end
end