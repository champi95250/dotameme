modifier_denied = class({})

--------------------------------------------------------------------------------

function modifier_denied:IsHidden()
	return true
end

function modifier_denied:IsDebuff()
	return false
end

function modifier_denied:IsPurgable()
	return false
end

function modifier_denied:RemoveOnDeath()
	return false
end

function modifier_denied:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_denied:CheckState()
	return{
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}
end


