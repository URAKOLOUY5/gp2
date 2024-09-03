-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Laser target delegate
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

local LASER_EXTENTS_DEFAULT = Vector(16, 16, 24)
local RELAY_EXTENTS = Vector(10, 10, 24)

local ALLOWED_CLASSES_TO_DAMAGE = {
    ["env_portal_laser"] = true
}

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Powered" )
    self:NetworkVar( "Bool", "TerminalPoint" )
    self:NetworkVar( "Entity", "LaserCatcher" )
end

function ENT.IsLaserTarget()
    return true
end

function ENT:Initialize()
    local parent = self:GetParent()
    local extents = LASER_EXTENTS_DEFAULT

    if IsValid(parent) and parent:GetClass() == "prop_laser_catcher" or parent:GetClass() == "prop_laser_relay" then
        self:SetLaserCatcher(parent)
    end

    parent = self:GetLaserCatcher()

    if self:GetTerminalPoint() then
        if IsValid(parent) then
            local angles = parent:GetAngles()
            local fwd, right, up = angles:Forward(), angles:Right(), angles:Up()
    
            extents = (right + up) * 20 + (fwd * 15)
    
            extents.x = math.abs(extents.x)
            extents.y = math.abs(extents.y)
            extents.z = math.abs(extents.z)
        else
            extents = LASER_EXTENTS_DEFAULT
        end
    else
        if IsValid(parent) then
            extents = RELAY_EXTENTS
        else
            extents = LASER_EXTENTS_DEFAULT
        end
    end

    self:SetCollisionBounds(-extents, extents)

    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:AddEffects(EF_NODRAW)

    debugoverlay.Box(self:GetPos(), -extents, extents, 16, color_white)
end

function ENT:KeyValue(k, v)
    if k == "terminalpoint" then
        self:SetTerminalPoint(tobool(v))
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:Think()
    if SERVER then
        if self:GetPowered() then
            self:PowerOff()
            self:NextThink(CurTime() + 0.1)
            return
        end
    end

    self:NextThink(CurTime())
    return
end

function ENT:OnTakeDamage(info)
    local attacker = info:GetAttacker()

    if not IsValid(info:GetAttacker()) then
        return
    end

    if not ALLOWED_CLASSES_TO_DAMAGE[info:GetAttacker():GetClass()] then
        return
    end

    self:PowerOn()
    self:NextThink(CurTime() + 0.1)
end

if SERVER then
    function ENT:PowerOn()    
        if self:GetPowered() then return end
    
        if IsValid(self:GetLaserCatcher()) then
            self:GetLaserCatcher():PowerOn()
        end

        self:SetPowered(true)
        self:TriggerOutput("OnPowered")
    end
    
    function ENT:PowerOff()
        if not self:GetPowered() then return end
    
        if IsValid(self:GetLaserCatcher()) then
            self:GetLaserCatcher():PowerOff()
        end

        self:SetPowered(false)
        self:TriggerOutput("OnUnpowered")
    end    
end