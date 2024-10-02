-- ----------------------------------------------------------------------------
-- GP2 Framework
-- A special kind of point_viewcontrol that follows the player with an offset.
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "point"
ENT.ProxyEntityName = ""

if SERVER then
    ENT.playerOffset = Vector(0,0,64)
    ENT.InitialPosition = Vector(0,0,0)
end

function ENT:SetupDataTables()
    self:NetworkVar( "Entity", 0, "ProxyTarget" )
    self:NetworkVar( "Bool", 0, "Enabled" )

    if SERVER then
        self:SetEnabled( false )
        self:SetProxyTarget( NULL )
    end
end

function ENT:Initialize()
    if SERVER then
        self.InitialPosition = self:GetPos()
        self:SetProxyTarget(ents.FindByName(self.ProxyEntityName)[1] or NULL)
        self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
        self:NextThink(CurTime())
        self:SetLagCompensated(false)
    end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

function ENT:KeyValue(k, v)
    if k == "proxy" then
        self.ProxyEntityName = v
    elseif k == "offsettype" then
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

ENT.__input2func = {
    ["enable"] = function(self, activator, caller, data)
        self:Enable()
    end,
    ["disable"] = function(self, activator, caller, data)
        self:Disable()
    end,
    ["teleportplayertoproxy"] = function(self, activator, caller, data)
        self:TeleportPlayerToProxy()
    end,
}

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:Think()
    if SERVER then
        if not self:GetEnabled() then return end
        local proxy = self:GetProxyTarget()

        if not proxy or not IsValid(proxy) then return end

        local proxyPos = proxy:GetPos()
        local offset = proxyPos
        self:SetPos(proxyPos + (Entity(1):GetPos() + self.playerOffset - self.InitialPosition))
        self:SetAngles(Entity(1):EyeAngles())
    end

    self:NextThink(CurTime())
    if CLIENT then
        self:SetNextClientThink(CurTime())
    end
    return true
end

if SERVER then
    function ENT:Enable()
        -- Disable others
        local views = ents.FindByClass("point_viewproxy")
    
        for _, view in pairs(views) do
            view:Disable()
        end
    
        self:SetEnabled(true)
        self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
        
        for _, ply in ipairs(player.GetHumans()) do
            ply:SetViewEntity(self)
        end
    end
    
    function ENT:Disable()
        self:SetEnabled(false)
        self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

        for _, ply in ipairs(player.GetHumans()) do
            ply:SetViewEntity(NULL)
        end
    end
    
    function ENT:TeleportPlayerToProxy()
        self:SetEnabled(false)
        self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

        for _, ply in ipairs(player.GetHumans()) do
            ply:SetViewEntity(NULL)
            local vel = ply:GetVelocity()
            ply:SetPos(self:GetPos())
            ply:SetVelocity(vel)
        end
    end
end