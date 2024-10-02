-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Aperture Testchamber Doors
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

util.PrecacheSound("prop_portal_door.open")
util.PrecacheSound("prop_portal_door.close")

if SERVER then
    ENT.IsAnimating = true
    ENT.AreaPortalWindowName = ""
end

local DOOR_MODEL = "models/props/portal_door_combined.mdl"
local DEFAULT_NOFADE = 16384.0

local bonefollowercheck = {
    ["phys_bone_follower"] = true
}

ENT.__input2func = {
    ["open"] = function(self, activator, caller, data)
        if self:GetIsLocked() then return end
        if self:GetIsOpen() then return end
        
        self:SetIsOpen(true)
        self:SetPlaybackRate(1.0)
        self:ResetSequence(self.sequenceOpen)

        self:TriggerOutput("OnOpen")
        self:EmitSound('prop_portal_door.open')

        self.IsAnimating = true

        if IsValid(self.AreaPortalWindow) then
            if self.UseAreaPortalFade then
                self.AreaPortalWindow:Fire("SetFadeEndDistance", tostring(self.AreaPortalFadeEnd))
                self.AreaPortalWindow:Fire("SetFadeStartDistance", self.AreaPortalFadeStart)
            else
                self.AreaPortalWindow:Fire("SetFadeEndDistance", DEFAULT_NOFADE)
                self.AreaPortalWindow:Fire("SetFadeStartDistance", DEFAULT_NOFADE)
            end   
        end
    end,
    ["close"] = function(self, activator, caller, data)
        if self:GetIsLocked() then return end
        if not self:GetIsOpen() then return end

        self:SetIsOpen(false)
        self:SetPlaybackRate(-1.0)
        self:ResetSequence(self.sequenceClose)

        self:TriggerOutput("OnClose")
        self:EmitSound('prop_portal_door.close')

        self.IsAnimating = true
    end,
    ["lock"] = function(self, activator, caller, data)
        if self:GetIsLocked() then return end

        self:SetIsLocked(true)
    end,
    ["unlock"] = function(self, activator, caller, data)
        if not self:GetIsLocked() then return end

        self:SetIsLocked(false)
    end,
}

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "IsOpen" )
    self:NetworkVar( "Bool", "IsLocked" )
end

function ENT:Initialize()
    self:AddEffects(EF_NOSHADOW)
    
    if SERVER then
        self:SetModel(DOOR_MODEL)
        self:CreateVPhysics()

        self.lightingOrigin = ents.Create("info_target")
        self.lightingOrigin:SetName("@_lighting_origin_" .. self.lightingOrigin:EntIndex())
        self.lightingOrigin:SetPos(self:GetPos() + self:GetAngles():Forward() * 69)
        self:Fire("setlightingorigin", self.lightingOrigin:GetName())
    end

    self.sequenceOpen = self:LookupSequence("open")
    self.sequenceOpenIdle = self:LookupSequence("idleopen")
    self.sequenceClose = self:LookupSequence("close")
    self.sequenceCloseIdle = self:LookupSequence("idleclose")
    
    self:ResetSequence(self.sequenceCloseIdle)
    self:SetPlaybackRate(0)

    self.AreaPortalWindow = ents.FindByName(self.AreaPortalWindowName)[1] or NULL
end

function ENT:KeyValue(k, v)
    if k == "AreaPortalWindow" then
        self.AreaPortalWindowName = v
    elseif k == "UseAreaPortalFade" then
        self.UseAreaPortalFade = tobool(v)
    elseif k == "AreaPortalFadeEnd" then
        self.AreaPortalFadeEnd = tonumber(v)
    elseif k == "AreaPortalFadeStart" then
        self.AreaPortalFadeStart = tonumber(v)
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:Think()
    if SERVER then
        self:UpdateBoneFollowers()
        self:NextThink( CurTime() )
        self:AnimateThink()
        return true
    end
end

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:OnRemove(fd)
    if SERVER then
        self:DestroyBoneFollowers()
    end
end

if SERVER then
    function ENT:CreateVPhysics()
        self:CreateBoneFollowers()
    
        if bit.band(self:GetSolidFlags(), FSOLID_NOT_SOLID) ~= 0 then
            local children = self:GetChildren()
    
            for _, child in pairs(children) do
                if bonefollowercheck[child:GetClass()] then
                    child:SetSolidFlags(FSOLID_NOT_SOLID)
                end
            end
        end
    end

    function ENT:AnimateThink()
        if self.IsAnimating then
            if self:IsSequenceFinished() then
                if self:GetIsOpen() then
                    self:TriggerOutput("OnFullyOpened")
                else
                    self:TriggerOutput("OnFullyClosed")
                    if IsValid(self.AreaPortalWindow) then
                        self.AreaPortalWindow:Fire("SetFadeEndDistance", 0)
                        self.AreaPortalWindow:Fire("SetFadeStartDistance", 0) 
                    end
                end

                self.IsAnimating = false
            end
        end
    end
end