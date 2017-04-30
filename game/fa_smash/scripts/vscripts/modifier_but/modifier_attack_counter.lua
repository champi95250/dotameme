modifier_attack_counter = class({})

--------------------------------------------------------------------------------

function modifier_attack_counter:IsHidden()
	return true
end

function modifier_attack_counter:IsDebuff()
	return false
end

function modifier_attack_counter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_attack_counter:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ATTACKED,
		}
	 
		return funcs
	end

--------------------------------------------------------------------------------

	function modifier_attack_counter:OnAttacked( event )
		local parent = self:GetParent()
		
		local chance = RandomInt(1, 10) 
		
		if chance == 1 then
		
			if event.target == parent and parent:HasAnyActiveAbilities() and not parent:IsIllusion() then
				if not event.attacker:IsHero() and RandomInt( 1, 10 ) > 2 then
					return
				end
				
				if not event.attacker:IsAlive() then
					return
				end
			
				local loc = event.attacker:GetAbsOrigin()
				
				--local exception_table = {}
				--table.insert(exception_table, "guimauve_skewer")
				--table.insert(exception_table, "pedobear_kidnap")
				
				local spellList = {}
				print("cast")
				
				for i = 0, 15 do
					local spell = parent:GetAbilityByIndex( i )
					
					if spell and not spell:IsPassive() and not spell:IsToggle() and spell:GetLevel() > 0 then
						table.insert( spellList, spell )
					end
				end
				
				local spellCast = spellList[RandomInt( 1, #spellList )]
				
				if spellCast then
					if bit.band( spellCast:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) > 0 then
						parent:SetCursorCastTarget( parent )
						parent:SetCursorPosition( parent:GetAbsOrigin() )
					else
						parent:SetCursorCastTarget( event.attacker )
						parent:SetCursorPosition( event.attacker:GetAbsOrigin() )
					end
					
					spellCast:OnSpellStart()
				end
			end
		end
	end
end
