-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Tractor Beam Emitter
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

PrecacheParticleSystem("tractor_beam_arm")
PrecacheParticleSystem("tractor_beam_core")

function ENT:KeyValue(k, v)
    if k == "use128model" then
        self.Use128Model = tobool(v)
    end
end

function ENT:Initialize()
    if self.Use128Model then
        self:SetModel("models/props_ingame/tractor_beam_128.mdl")
    else
        self:SetModel("models/props/tractor_beam_emitter.mdl")
    end

    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:ResetSequence(2)
    self:AddEffects(EF_NOSHADOW)
end

function ENT:Project()

end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end