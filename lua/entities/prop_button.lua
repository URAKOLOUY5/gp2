-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Pillar style button
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

if SERVER then
    ENT.NextReleaseTime = 0
    ENT.NextTickSoundTime = 0
end

util.PrecacheSound("Portal.button_down")
util.PrecacheSound("Portal.button_up")
util.PrecacheSound("Portal.button_locked")
util.PrecacheSound("Portal.room1_TickTock")

ENT.__input2func = {
    ["press"] = function(self, activator, caller, data)
        self:Press()
    end,
    ["lock"] = function(self, activator, caller, data)
        self:Lock()
    end,   
    ["unlock"] = function(self, activator, caller, data)
        self:Unlock()
    end,
    ["cancelpress"] = function(self, activator, caller, data)
        self:CancelPress()
    end,    
}

function ENT:Initialize()
    self:SetModel(self:GetButtonModelName())
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

    self.UpSequence = self:LookupSequence( "up" )
    self.DownSequence = self:LookupSequence( "down" )

    self.SoundDown = "Portal.button_down"
    self.SoundUp = "Portal.button_up"
end

function ENT:GetButtonModelName()
    return "models/props/switch001.mdl"
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "IsPressed" )
    self:NetworkVar( "Bool", "IsLocked" )
end

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:KeyValue(k, v)
    if k == "Delay" then
        self.DelayBeforeReset = tonumber(v)
    elseif k == "preventfastreset" then
        self.PreventFastReset = tobool(v) -- unused idk
    elseif k == "istimer" then
        self.HasTimer = tobool(v)
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:Use(activator, caller, useType, value)
    self:Press()
end

function ENT:Press()
    if self:GetIsLocked() then return end
    if self:GetIsPressed() then return end

    self:SetIsPressed(true)
    self:EmitSound(self.SoundDown)
    self:ResetSequence(self.DownSequence)
    self:TriggerOutput("OnPressed")
    self.NextReleaseTime = CurTime() + self.DelayBeforeReset
end

function ENT:CancelPress()
    self:SetIsPressed(false)
    self:EmitSound(self.SoundUp)
    self:ResetSequence(self.UpSequence)
end

function ENT:Lock()
    self:SetIsLocked(true)
end

function ENT:Unlock()
    self:SetIsLocked(false)
end

function ENT:Think()
    if SERVER then
        if self:GetIsPressed() then
            if CurTime() > self.NextReleaseTime then
                self:CancelPress()
                self:TriggerOutput("OnButtonReset")
            else
                if self.HasTimer and CurTime() > self.NextTickSoundTime then
                    self:EmitSound("Portal.room1_TickTock")
                    self.NextTickSoundTime = CurTime() + 1
                end
            end
        end
    end

    self:NextThink(CurTime() + 0.01)
    return true    
end