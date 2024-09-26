-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Sentry turret with 3 legs and fancy laser
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.PrintName = "Sentry Turret"
ENT.Category = "Portal 2"

function ENT:SetupDataTables()
    self:NetworkVar("Int", "Range")
    self:NetworkVar("Int", "State")
    self:NetworkVar("Int", "EyeState")
    
    self:NetworkVar("Bool", "IsActive")
    self:NetworkVar("Bool", "HasAmmo")
    self:NetworkVar("Bool", "DamageForce")
    self:NetworkVar("Bool", "UseSuperDamageScale")
    self:NetworkVar("Bool", "IsAsActor")
    self:NetworkVar("Bool", "IsGagged")
    self:NetworkVar("Bool", "CanShootThroughPortals")
    self:NetworkVar("Bool", "PickupEnabled")

    if SERVER then
        self:SetRange(1024)
        self:SetHasAmmo(true)
        self:SetIsActive(true)
        self:SetPickupEnabled(true)
    end
end