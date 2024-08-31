-- ----------------------------------------------------------------------------
-- GP2
-- Movies
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "point"

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Active" )
    self:NetworkVar( "Bool", "IsLooping" )
    self:NetworkVar( "Bool", "IsStretching" )
    self:NetworkVar( "Bool", "IsMaster" )
    self:NetworkVar( "Int", "Frame" )
    self:NetworkVar( "Float", "UMin" )
    self:NetworkVar( "Float", "UMax" )
    self:NetworkVar( "Float", "VMin" )
    self:NetworkVar( "Float", "VMax" )
    self:NetworkVar( "String", "Movie" )
    self:NetworkVar( "String", "DisplayText" )
    self:NetworkVar( "String", "GroupName" )
    self:NetworkVar( "Vector", "Size" ) -- Vector2 (z is not used)

    self:NetworkVarNotify("Active", self.OnActiveChanged)

    if SERVER then
        self:SetSize(Vector(256, 128, 0))
        self:SetIsMaster(true)
        self:SetUMin(0.0)
        self:SetUMax(1.0)
        self:SetVMin(0.0)
        self:SetVMax(1.0)
    end
end

function ENT:Initialize()
end

function ENT:OnActiveChanged(name, old, new)
end

function ENT:UpdateTransmitState()
    if self:GetActive() then
        net.Start(GP2.Net.SendMovieDisplay)
            net.WriteEntity(self)
        net.Broadcast()
    end

    return TRANSMIT_ALWAYS
end

if SERVER then
    function ENT:KeyValue(k, v)
        if k == "moviefilename" then
            self:SetMovie(v)
        elseif k == "groupname" then
            self:SetGroupName(v)
        elseif k == "looping" then
            self:SetIsLooping(tobool(v))
        elseif k == "width" then
            local size = self:GetSize()
            size.x = tonumber(v)
            self:SetSize(size)
        elseif k == "forcedslave" then
            self:SetIsMaster(false)
        end
    
        if k:StartsWith("On") then
            self:StoreOutput(k, v)
        end
    end

    function ENT:DelegateInputToOthers(input, activator, caller, data)
        if self:GetIsMaster() then
            for _, slave in ipairs(ents.FindByClass(self:GetClass())) do
                if slave == self then continue end
                if slave:GetIsMaster() then continue end
                if slave:GetGroupName() ~= self:GetGroupName() then continue end

                slave:Input(input, activator, caller, data)
            end
        end
    end

    function ENT:AcceptInput(name, activator, caller, data)
        name = name:lower()
    
        if name == "enable" then
            self:SetActive(true)

            net.Start(GP2.Net.SendMovieDisplay) 
                net.WriteEntity(self)
            net.Broadcast()
        elseif name == "disable" then
            self:SetActive(false)

            net.Start(GP2.Net.SendRemoveMovieDisplay)
                net.WriteEntity(self)
            net.Broadcast()            
        elseif name == "setmovie" then
            self:SetMovie(data)
        elseif name == "setumin" then
            self:SetUMin(tonumber(data))
        elseif name == "setumax" then
            self:SetUMax(tonumber(data))
        elseif name == "setvmin" then
            self:SetVMin(tonumber(data))
        elseif name == "setvmax" then
            self:SetVMax(tonumber(data))
        end

        self:DelegateInputToOthers(name, activator, caller, data)
    end    
end