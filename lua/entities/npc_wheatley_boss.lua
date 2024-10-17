-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Boss Wheatley
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true

ENT.m_fMaxYawSpeed = 200
ENT.m_iClass = CLASS_PLAYER_ALLY

function ENT:Initialize()
    if CLIENT then return end
    
    self:SetSolid(SOLID_NONE)
    self:SetBloodColor(DONT_BLEED)
    self:SetHealth(8000)
    self:CapabilitiesClear()
    self:CapabilitiesAdd(CAP_TURN_HEAD + CAP_ANIMATEDFACE)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetMoveYawLocked(true)

    self:CreateBoneFollowers()
end

function ENT:KeyValue(k, v)   
    if k == "model" then
        self:SetModel(v)
    end
end

function ENT:Think()
    if SERVER then
        self:UpdateBoneFollowers()
    end

    self:NextThink(CurTime())
    return true
end