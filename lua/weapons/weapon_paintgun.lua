-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Paint gun
-- ----------------------------------------------------------------------------

AddCSLuaFile()
SWEP.Slot = 0
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_portalgun.mdl"
SWEP.WorldModel = "models/weapons/w_portalgun.mdl"
SWEP.ViewModelFOV = 54
SWEP.Automatic = true

SWEP.Primary.Ammo = "None"
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "None"
SWEP.Secondary.Automatic = true

SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true

SWEP.PrintName = "Paint Gun"
SWEP.Category = "Portal 2"

local gp2_blobulator_debug = GetConVar("gp2_blobulator_debug")

function SWEP:Initialize()
    self:SetDeploySpeed(1)
    self:SetHoldType("shotgun")


    self.NextIdleTime = 0
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", "IsPotatoGun")
end

function SWEP:Holster(arguments)
    self:GetOwner():GetViewModel(0):SetColor4Part(255,255,255,255)
    return true
end

function SWEP:Deploy()
    timer.Simple(0.1, function()
        self:GetOwner():GetViewModel(0):SetColor4Part(255,5,255,255)
    end)
    return true
end

function SWEP:PrimaryAttack()
    self:GetOwner():GetViewModel(0):SetColor4Part(255,200,0,255)
    self:SetNextPrimaryFire(CurTime() + 0.1)
    self.NextIdleTime = CurTime() + 0.1

    if SERVER then
        self:DoTraceToSurface()
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
    if SERVER then
        if CurTime() > self.NextIdleTime and self:GetActivity() ~= ACT_VM_IDLE then
            self:SendWeaponAnim(ACT_VM_IDLE)
        end
    end
end

function SWEP:Reload()
end

function SWEP:ViewModelDrawn(vm)
    vm:SetColor4Part(0,165,255,255)
end

function SWEP:DoTraceToSurface()
    local owner = self:GetOwner()
    if not owner:IsPlayer() then return end

    local tr = owner:GetEyeTrace()
    
    local surfaceId = PaintManager.GetSurfaceByTrace(tr.StartPos, tr.Normal)
    print(surfaceId)
end