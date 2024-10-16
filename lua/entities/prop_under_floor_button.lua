-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Floor button (underground), just uses prop_floor_button as base
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true -- Enable automatic frame advancement

DEFINE_BASECLASS( "prop_floor_button" )

local DEFAULT_BUTTON_MODEL = "models/props_underground/underground_floor_button.mdl"

function ENT:Initialize()
    self.BaseClass.Initialize(self)

    if SERVER then
        self:SetModel(DEFAULT_BUTTON_MODEL)
        self:CreateBoneFollowers()
        self.SequenceDown = self:LookupSequence("press")
        self.SequenceUp = self:LookupSequence("unpress")
    end
end