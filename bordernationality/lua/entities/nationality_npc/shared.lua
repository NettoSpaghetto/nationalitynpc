ENT.Base                    = "base_ai"
ENT.Type                    = "ai"
ENT.PrintName               = "Nationality NPC"
ENT.Category                = "netto"
ENT.Instructions			= "Change your nationality."
ENT.AutomaticFrameAdvance   = true
ENT.Spawnable               = true
ENT.AdminOnly               = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end