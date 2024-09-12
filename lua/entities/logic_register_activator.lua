-- ----------------------------------------------------------------------------
-- GP2 Framework
-- https://developer.valvesoftware.com/wiki/Logic_register_activator
-- ----------------------------------------------------------------------------

ENT.Type = "point"

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Enabled" )
    self:NetworkVar( "Entity", "RegisteredEntity" )

    if SERVER then
        self:SetEnabled(true)
    end
end

function ENT:KeyValue(k, v)
    if k == "StartDisabled" then
        self:SetEnabled(false)
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    if name:StartsWith("fireregisteredasactivator") and self:GetEnabled() then
        local value = name:Replace("fireregisteredasactivator", "")

        self:TriggerOutput("OnRegisteredActivate" .. value, self:GetRegisteredEntity())
    elseif name == "registerentity" then
        local ent 

        if data == "!activator" then
            ent = activator
        elseif data == "!caller" then
            ent = caller
        else
            ent = ents.FindByName(data)[1]
        end

        self:SetRegisteredEntity(ent)
    elseif name == "enable" then
        self:SetEnabled(true)
    elseif name == "disable" then
        self:SetEnabled(false)
    elseif name == "toggle" then
        self:SetEnabled(not self:GetEnabled())
    end
end