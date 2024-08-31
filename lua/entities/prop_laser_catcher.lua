-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Laser catcher
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true -- Enable automatic frame advancement

util.PrecacheSound("prop_laser_catcher.poweron")
util.PrecacheSound("prop_laser_catcher.poweroff")

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Powered" )
end

function ENT:KeyValue(k, v)
    if k == "model" then
        self:SetModel(v)
    elseif k == "skin" then
        self:SetSkin(tonumber(v))
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:Initialize()
    if self:GetModel() then
        self:PhysicsInitStatic(SOLID_VPHYSICS)
    end

    if SERVER then
        self.SequenceIdle = self:LookupSequence("idle")
        self.SequenceSpin = self:LookupSequence("spin")

        self.LaserTarget = ents.Create("point_laser_target")
        self.LaserTarget:SetParent(self)
        self.LaserTarget:SetPos(self:GetPos())
        self.LaserTarget:Spawn()
    end
end

function ENT:Think()
    if CLIENT then
        if self:GetPowered() and not self.Particle then
            self.Particle = CreateParticleSystem(self, "laser_relay_powered", PATTACH_POINT_FOLLOW, self:LookupAttachment("particle_emitter"))
        elseif not self:GetPowered() and self.Particle then
            self.Particle:StopEmission()
            self.Particle = nil
        end
    end

    self:NextThink(CurTime())
    return true
end

function ENT:IsLaserCatcher()
    return true
end

if SERVER then
    function ENT:OnRemove(fd)
        if self.SoundPowerLoop and self.SoundPowerLoop ~= -1 then
            self:StopLoopingSound(self.SoundPowerLoop)
        end
    end

    function ENT:PowerOn()
        if not IsValid(self.LaserTarget) then
            return
        end

        self:SetPowered(true)
        self:TriggerOutput("OnPowered")
        self:SetSkin(1)
        self:ResetSequence(self.SequenceSpin)
        
        self:EmitSound("prop_laser_catcher.poweron")
        self.SoundPowerLoop = self:StartLoopingSound("prop_laser_catcher.powerloop")
    end

    function ENT:PowerOff()
        if not IsValid(self.LaserTarget) then
            return
        end

        self:SetPowered(false)
        self:TriggerOutput("OnUnpowered")
        self:SetSkin(0)
        self:ResetSequence(self.SequenceIdle)

        self:EmitSound("prop_laser_catcher.poweroff")
        if self.SoundPowerLoop and self.SoundPowerLoop ~= -1 then
            self:StopLoopingSound(self.SoundPowerLoop)
        end
    end
end