-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Pillar button (underground), just uses prop_button as base
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true -- Enable automatic frame advancement

DEFINE_BASECLASS( "prop_button" )

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    
    self.UpSequence = self:LookupSequence( "unpress" )
    self.DownSequence = self:LookupSequence( "press" )

    self.SoundDown = ''
    self.SoundUp = ''
end

function ENT:GetButtonModelName()
    return "models/props_underground/underground_testchamber_button.mdl"
end