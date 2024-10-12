-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Hard Light projector
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

function ENT:Initialize()
    self:SetModel("models/props/wall_emitter.mdl")
    
    if SERVER then
        self:PhysicsInitStatic(SOLID_VPHYSICS)

        if self.StartEnabled then
            self:Enable()
        end
    end
end

function ENT:KeyValue(k, v)
    if k == "StartEnabled" then
        self.StartEnabled = tobool(v)
    elseif k == "skin" then
        self:SetSkin(tonumber(v))
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end


function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    if name == "enable" then
        self:Enable()  
    elseif name == "disable" then
        self:Disable()
    end
end 

if SERVER then
    function ENT:Enable()
        if not (self.WallEntity and IsValid(self.WallEntity)) then
            self.WallEntity = ents.Create("projected_wall_entity")
            local ang = self:GetAngles()
            self.WallEntity:Spawn()
            self.WallEntity:SetPos(self:GetPos() + ang:Forward() * 8)
            self.WallEntity:SetParent(self)
            self.WallEntity:SetAngles(ang)

        end
    end

    function ENT:Disable()
        if self.WallEntity and IsValid(self.WallEntity) then
            self.WallEntity:Remove()
            self.WallEntity = nil
        end
    end
end